# AI Status Light Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** A generic `bin/ai-light` CLI that any tool can push a status into, which arbitrates between concurrent sources and drives the physical LAN status light.

**Architecture:** No daemon. Each caller writes a one-line claim file per source under a state dir, then the same invocation recomputes the winning state (priority tier, then state urgency, expired claims dropped) and POSTs it to the light only if the winner changed. A thin Claude Code hook wrapper lives outside this repo and translates hook JSON into `ai-light` calls.

**Tech Stack:** POSIX `sh`, `curl`. No dependencies, no framework.

**Spec:** `docs/superpowers/specs/2026-07-13-ai-status-light-design.md`

## Global Constraints

- macOS system bash is 3.2 — no `declare -A`, no arrays. Write POSIX `sh` (`#!/bin/sh`), matching the style of `bin/gh-active-user`.
- The script must NEVER fail its caller. Network errors, an unplugged light, a
  missing state dir — all are swallowed. It is invoked from Claude Code hooks and
  from build pipelines; a non-zero exit there is a bug. (Exception: usage errors
  — an invalid state name or unknown subcommand — exit 2, because those are
  programmer errors, not runtime conditions.)
- Valid states, exactly: `ready thinking working waiting error off`.
- Urgency order: `error` > `waiting` > `working` > `thinking` > `ready`.
- Priority tiers, exactly two: `alert` beats `normal`. No numeric scale.
- `off` is not a colour — it means "this source has nothing to say" and is
  equivalent to clearing that source.
- Defaults: `--source default`, `--ttl 60`, `--priority normal`.
- Device host: `${AI_LIGHT_HOST:-192.168.2.24}`. Never mDNS — resolution latency
  lands on every Claude tool call.
- State dir: `${AI_LIGHT_DIR:-${TMPDIR:-/tmp}/ai-light}`. The env override exists
  so tests get an isolated dir.
- Device endpoint: `GET http://<host>/state?value=<state>`.
- `~/.claude/` is NOT tracked by this repo. The hook wrapper written in Task 4
  must never be `git add`ed here.
- Commit messages in this repo are terse and lowercase (`update.`, `install cargo.`).

## File Structure

- `bin/ai-light` — the whole CLI. Subcommands `set`, `clear`, `status`. Knows
  nothing about Claude Code.
- `test/ai-light.test.sh` — plain `sh` test script, no framework. Run with
  `sh test/ai-light.test.sh`. This repo has no test suite today; this is the
  first one, and it is deliberately a single self-contained file with zero deps.
- `~/.claude/hooks/ai-light.sh` — (outside this repo) reads hook JSON on stdin,
  maps event → state, calls `ai-light set --source <session_id>`.
- `~/.claude/settings.json` — (outside this repo) four hooks gain one command each.

Tests drive `ai-light status`, which computes and prints the winner **without
touching the network**. That is why no `curl` stubbing is needed for the
arbitration tests (Tasks 1–2); only the transport test (Task 3) stubs `curl`.

---

### Task 1: State store — `set`, `clear`, and `status` listing

**Files:**
- Create: `bin/ai-light`
- Test: `test/ai-light.test.sh`

**Interfaces:**
- Produces:
  - `ai-light set <state> [--source NAME] [--ttl SECONDS] [--priority normal|alert]`
  - `ai-light clear [--source NAME]`
  - `ai-light status` — prints one `source <name> <state> <priority> <ttl>` line
    per live source, then a final `winner: <state>` line.
  - Claim file format, one line: `<state> <ttl> <priority> <mtime-epoch>`, at
    `$AI_LIGHT_DIR/<source>`.
  - Exit 2 on invalid state or unknown subcommand; exit 0 otherwise.

In this task `status` always prints `winner: off` — real arbitration is Task 2.

- [ ] **Step 1: Write the failing test**

Create `test/ai-light.test.sh`:

```sh
#!/bin/sh
# ai-light test suite. Run: sh test/ai-light.test.sh
#
# No framework, no deps. Each test gets a fresh AI_LIGHT_DIR so claims from one
# test can never leak into the next.
set -u

root=$(cd "$(dirname "$0")/.." && pwd)
ai_light="$root/bin/ai-light"
fails=0

check() { # check <desc> <expected> <actual>
  if [ "$2" = "$3" ]; then
    printf 'ok   %s\n' "$1"
  else
    printf 'FAIL %s\n       expected: [%s]\n       actual:   [%s]\n' "$1" "$2" "$3"
    fails=$((fails + 1))
  fi
}

fresh() { # start a test with an empty state dir
  AI_LIGHT_DIR=$(mktemp -d)
  export AI_LIGHT_DIR
}

winner() { "$ai_light" status | sed -n 's/^winner: //p'; }

# --- state store ---------------------------------------------------------

fresh
"$ai_light" set working --source a
check 'set writes a claim file' 'working 60 normal' \
  "$(cut -d' ' -f1-3 "$AI_LIGHT_DIR/a")"

fresh
"$ai_light" set thinking --source a --ttl 5 --priority alert
check 'set records ttl and priority' 'thinking 5 alert' \
  "$(cut -d' ' -f1-3 "$AI_LIGHT_DIR/a")"

fresh
"$ai_light" set working
check 'source defaults to "default"' 'working' \
  "$(cut -d' ' -f1 "$AI_LIGHT_DIR/default")"

fresh
"$ai_light" set working --source a
"$ai_light" clear --source a
check 'clear removes the claim file' 'gone' \
  "$([ -e "$AI_LIGHT_DIR/a" ] && echo present || echo gone)"

fresh
"$ai_light" set working --source a
"$ai_light" set off --source a
check 'off is equivalent to clear' 'gone' \
  "$([ -e "$AI_LIGHT_DIR/a" ] && echo present || echo gone)"

fresh
"$ai_light" set bogus --source a 2>/dev/null
check 'invalid state exits 2' '2' "$?"
check 'invalid state writes nothing' 'gone' \
  "$([ -e "$AI_LIGHT_DIR/a" ] && echo present || echo gone)"

fresh
"$ai_light" set working --source a
check 'status lists the source' 'source a working normal 60' \
  "$("$ai_light" status | grep '^source ')"

# --- summary -------------------------------------------------------------

if [ "$fails" -gt 0 ]; then
  printf '\n%s test(s) failed\n' "$fails"
  exit 1
fi
printf '\nall tests passed\n'
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `sh test/ai-light.test.sh`
Expected: every test FAILs (`bin/ai-light` does not exist yet, so `$ai_light`
invocations print "No such file or directory" and produce empty output).

- [ ] **Step 3: Write the minimal implementation**

Create `bin/ai-light`:

```sh
#!/bin/sh
# ai-light — drive the LAN AI status light.
#
# A general ambient status indicator: any tool can push a state, and this
# script arbitrates between concurrent sources before touching the device.
# It knows nothing about Claude Code (see ~/.claude/hooks/ai-light.sh for that).
#
#   ai-light set <state> [--source NAME] [--ttl SECONDS] [--priority alert]
#   ai-light clear [--source NAME]
#   ai-light status
#
# <state> is one of: ready thinking working waiting error off
#
# Each source holds a claim (a one-line file) that expires after --ttl seconds.
# Expiry is what keeps the light honest: a session that is killed never sends a
# terminal state, and a physical light stuck in the wrong state is worse than a
# dark one.
#
# Never fails its caller: it runs inside Claude Code hooks and build pipelines,
# where a non-zero exit would be actively harmful. Usage errors are the one
# exception (exit 2) — those are bugs in the caller, not runtime conditions.

set -u

host="${AI_LIGHT_HOST:-192.168.2.24}"
dir="${AI_LIGHT_DIR:-${TMPDIR:-/tmp}/ai-light}"

usage() {
  sed -n '4,10p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
}

# Sources are used as filenames and arrive from callers (a Claude session_id, a
# script's name); keep them to a safe charset rather than trusting them.
sanitize() {
  printf %s "$1" | tr -c 'A-Za-z0-9_-' '_'
}

valid_state() {
  case "$1" in
    ready|thinking|working|waiting|error|off) return 0 ;;
    *) return 1 ;;
  esac
}

cmd_set() {
  [ $# -ge 1 ] || usage
  state="$1"
  shift
  valid_state "$state" || usage

  source=default
  ttl=60
  priority=normal
  while [ $# -gt 0 ]; do
    case "$1" in
      --source) source="${2:-}"; shift 2 || usage ;;
      --ttl) ttl="${2:-}"; shift 2 || usage ;;
      --priority) priority="${2:-}"; shift 2 || usage ;;
      *) usage ;;
    esac
  done
  case "$priority" in normal|alert) ;; *) usage ;; esac

  source=$(sanitize "$source")
  mkdir -p "$dir" 2>/dev/null || return 0

  if [ "$state" = off ]; then
    rm -f "$dir/$source"
  else
    # Write-then-rename: a concurrent reader never sees a half-written claim.
    tmp="$dir/.tmp.$$"
    printf '%s %s %s %s\n' "$state" "$ttl" "$priority" "$(date +%s)" >"$tmp" &&
      mv -f "$tmp" "$dir/$source"
  fi
}

cmd_clear() {
  source=default
  while [ $# -gt 0 ]; do
    case "$1" in
      --source) source="${2:-}"; shift 2 || usage ;;
      *) usage ;;
    esac
  done
  rm -f "$dir/$(sanitize "$source")"
}

cmd_status() {
  now=$(date +%s)
  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    read -r st ttl prio mt <"$f" || continue
    [ $((now - mt)) -gt "$ttl" ] && continue
    printf 'source %s %s %s %s\n' "${f##*/}" "$st" "$prio" "$ttl"
  done
  printf 'winner: off\n'
}

[ $# -ge 1 ] || usage
subcommand="$1"
shift
case "$subcommand" in
  set) cmd_set "$@" ;;
  clear) cmd_clear "$@" ;;
  status) cmd_status "$@" ;;
  *) usage ;;
esac
exit 0
```

- [ ] **Step 4: Make it executable and run the tests**

```bash
chmod +x bin/ai-light
sh test/ai-light.test.sh
```

Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add bin/ai-light test/ai-light.test.sh
git commit -m "ai-light: state store for status claims."
```

---

### Task 2: Arbitration

**Files:**
- Modify: `bin/ai-light` (replace the stub `winner: off` line in `cmd_status`)
- Test: `test/ai-light.test.sh` (append an arbitration section)

**Interfaces:**
- Consumes: the claim file format and `cmd_status` from Task 1.
- Produces: a `compute_winner` shell function printing the winning state to
  stdout (one of the six state names). `ai-light status` prints it as
  `winner: <state>`. No network I/O.

Arbitration rules, in order: drop expired claims; highest priority tier wins
(`alert` > `normal`); within a tier, highest state urgency wins
(`error` > `waiting` > `working` > `thinking` > `ready`); no live claims → `off`.

There is deliberately no recency tiebreak. Urgency is a pure function of state,
so two claims that tie on urgency hold the same state and produce the same
winner regardless of order.

- [ ] **Step 1: Write the failing tests**

Append to `test/ai-light.test.sh`, immediately BEFORE the `# --- summary` section:

```sh
# --- arbitration ---------------------------------------------------------

fresh
check 'no sources means off' 'off' "$(winner)"

fresh
"$ai_light" set thinking --source a
check 'a single source wins' 'thinking' "$(winner)"

fresh
"$ai_light" set working --source a
"$ai_light" set waiting --source b
check 'higher urgency wins within a tier' 'waiting' "$(winner)"

fresh
"$ai_light" set thinking --source a
"$ai_light" set error --source b
check 'error outranks everything in its tier' 'error' "$(winner)"

fresh
"$ai_light" set waiting --source a
"$ai_light" set working --source b --priority alert
check 'alert beats a more urgent normal claim' 'working' "$(winner)"

fresh
"$ai_light" set working --source a --priority alert
"$ai_light" set thinking --source b --priority alert
check 'urgency still decides inside the alert tier' 'working' "$(winner)"

fresh
printf 'working 60 normal %s\n' "$(( $(date +%s) - 61 ))" >"$AI_LIGHT_DIR/stale"
check 'expired claims are ignored' 'off' "$(winner)"

fresh
printf 'working 60 normal %s\n' "$(( $(date +%s) - 61 ))" >"$AI_LIGHT_DIR/stale"
"$ai_light" set thinking --source live
check 'an expired claim cannot mask a live one' 'thinking' "$(winner)"

fresh
"$ai_light" set working --source a
"$ai_light" set off --source a
check 'off retires the source' 'off' "$(winner)"
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `sh test/ai-light.test.sh`
Expected: the Task 1 tests still pass; every new arbitration test except
`no sources means off` and `expired claims are ignored` FAILs with
`expected: [...] actual: [off]` — the stub always prints `off`.

- [ ] **Step 3: Write the implementation**

In `bin/ai-light`, add these two functions immediately after `valid_state`:

```sh
# Rank helpers. Higher number wins. Printed rather than returned because sh
# exit codes are a terrible place to put data.
urgency() {
  case "$1" in
    error) echo 5 ;;
    waiting) echo 4 ;;
    working) echo 3 ;;
    thinking) echo 2 ;;
    ready) echo 1 ;;
    *) echo 0 ;;
  esac
}

tier() {
  case "$1" in
    alert) echo 2 ;;
    *) echo 1 ;;
  esac
}

# The winning state across all live claims: highest tier, then highest urgency.
# Expired claims are skipped, which is how a killed session releases the light.
compute_winner() {
  now=$(date +%s)
  best=off
  best_tier=0
  best_urgency=0

  for f in "$dir"/*; do
    [ -f "$f" ] || continue
    case "${f##*/}" in .*) continue ;; esac
    read -r st ttl prio mt <"$f" || continue
    [ $((now - mt)) -gt "$ttl" ] && continue

    t=$(tier "$prio")
    u=$(urgency "$st")
    if [ "$t" -gt "$best_tier" ] ||
      { [ "$t" -eq "$best_tier" ] && [ "$u" -gt "$best_urgency" ]; }; then
      best="$st"
      best_tier="$t"
      best_urgency="$u"
    fi
  done

  printf '%s\n' "$best"
}
```

Then replace the stub line in `cmd_status`:

```sh
  printf 'winner: off\n'
```

with:

```sh
  printf 'winner: %s\n' "$(compute_winner)"
```

- [ ] **Step 4: Run the tests to verify they pass**

Run: `sh test/ai-light.test.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Commit**

```bash
git add bin/ai-light test/ai-light.test.sh
git commit -m "ai-light: arbitrate between concurrent sources."
```

---

### Task 3: Transport — push to the device, only on change

**Files:**
- Modify: `bin/ai-light` (add a `push` function; call it from `cmd_set` and `cmd_clear`)
- Test: `test/ai-light.test.sh` (append a transport section)

**Interfaces:**
- Consumes: `compute_winner` from Task 2.
- Produces: a `push` shell function that computes the winner and, if it differs
  from the value cached in `$AI_LIGHT_DIR/.last`, issues
  `curl -s --max-time 1 "http://$host/state?value=<winner>"`. `.last` is updated
  only when curl succeeds, so a failed request is retried on the next call
  rather than being silently swallowed forever.

The change check is what makes the high-frequency Claude hook affordable: ten
consecutive `Bash` tool calls yield one HTTP request and nine local file reads.

Tests stub `curl` by prepending a fake to `PATH`; the stub logs its arguments so
tests can assert on how many requests were made and with what value.

- [ ] **Step 1: Write the failing tests**

First, add a curl stub helper. In `test/ai-light.test.sh`, insert this
immediately after the `winner()` helper definition:

```sh
# A fake curl on PATH: logs each invocation's URL, and fails when
# CURL_SHOULD_FAIL is set, so we can test the retry behaviour.
stub_curl() {
  stubdir=$(mktemp -d)
  cat >"$stubdir/curl" <<'STUB'
#!/bin/sh
for arg in "$@"; do
  case "$arg" in http*) printf '%s\n' "$arg" >>"$CURL_LOG" ;; esac
done
[ -n "${CURL_SHOULD_FAIL:-}" ] && exit 7
exit 0
STUB
  chmod +x "$stubdir/curl"
  PATH="$stubdir:$PATH"
  export PATH
  CURL_LOG=$(mktemp)
  export CURL_LOG
  unset CURL_SHOULD_FAIL
}

requests() { wc -l <"$CURL_LOG" | tr -d ' '; }
```

Then append this section immediately BEFORE the `# --- summary` section:

```sh
# --- transport -----------------------------------------------------------

fresh; stub_curl
"$ai_light" set working --source a
check 'a new winner is pushed to the light' \
  'http://192.168.2.24/state?value=working' "$(cat "$CURL_LOG")"

fresh; stub_curl
AI_LIGHT_HOST=10.0.0.9 "$ai_light" set ready --source a
check 'AI_LIGHT_HOST overrides the device address' \
  'http://10.0.0.9/state?value=ready' "$(cat "$CURL_LOG")"

fresh; stub_curl
"$ai_light" set working --source a
"$ai_light" set working --source a
"$ai_light" set working --source b
check 'an unchanged winner is not re-pushed' '1' "$(requests)"

fresh; stub_curl
"$ai_light" set working --source a
"$ai_light" set error --source b
check 'a changed winner is pushed again' '2' "$(requests)"

fresh; stub_curl
"$ai_light" set working --source a
"$ai_light" clear --source a
check 'clearing the last source pushes off' \
  'http://192.168.2.24/state?value=off' "$(sed -n 2p "$CURL_LOG")"

fresh; stub_curl
CURL_SHOULD_FAIL=1 "$ai_light" set working --source a
check 'a failed push exits 0 anyway' '0' "$?"
"$ai_light" set working --source a
check 'a failed push is retried on the next call' '2' "$(requests)"
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `sh test/ai-light.test.sh`
Expected: Tasks 1–2 tests still pass; every transport test FAILs — nothing calls
curl yet, so `$CURL_LOG` is empty and `requests` returns `0`.

- [ ] **Step 3: Write the implementation**

In `bin/ai-light`, add `last="$dir/.last"` directly under the `dir=` assignment:

```sh
dir="${AI_LIGHT_DIR:-${TMPDIR:-/tmp}/ai-light}"
last="$dir/.last"
```

Add this function immediately after `compute_winner`:

```sh
# Send the current winner to the device — but only if it changed. Claude's
# PreToolUse hook fires on every single tool call; without this check the light
# would be hammered and the hook would pay a round-trip each time.
#
# Short timeout, output discarded, never returns non-zero: an unplugged light
# must not break a build or a hook. `.last` is written only on success, so a
# request that failed is retried on the next call instead of being lost.
push() {
  new=$(compute_winner)
  old=$(cat "$last" 2>/dev/null) || old=
  [ "$new" = "$old" ] && return 0

  if curl -s --max-time 1 "http://$host/state?value=$new" >/dev/null 2>&1; then
    printf '%s' "$new" >"$last" 2>/dev/null || true
  fi
  return 0
}
```

Then call it at the end of both mutating subcommands. `cmd_set` ends with the
`if [ "$state" = off ]` block — append `push` after that block's `fi`:

```sh
    tmp="$dir/.tmp.$$"
    printf '%s %s %s %s\n' "$state" "$ttl" "$priority" "$(date +%s)" >"$tmp" &&
      mv -f "$tmp" "$dir/$source"
  fi

  push
}
```

And `cmd_clear` ends with its `rm -f` — append `push` after it:

```sh
  rm -f "$dir/$(sanitize "$source")"
  push
}
```

Note `cmd_status` does NOT call `push`. Inspecting the state must never change it.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `sh test/ai-light.test.sh`
Expected: `all tests passed`.

- [ ] **Step 5: Verify against the real device**

```bash
bin/ai-light set thinking --source manual
bin/ai-light status
bin/ai-light clear --source manual
```

Expected: the physical light turns on for `thinking`, `status` prints
`source manual thinking normal 60` and `winner: thinking`, and the light goes
out on `clear`. If the light is unreachable, all three commands must still exit
0 — that is the design, not a failure.

- [ ] **Step 6: Commit**

```bash
git add bin/ai-light test/ai-light.test.sh
git commit -m "ai-light: push winner to the device on change."
```

---

### Task 4: Claude Code integration

**Files:**
- Create: `~/.claude/hooks/ai-light.sh` (OUTSIDE this repo — never `git add` it)
- Modify: `~/.claude/settings.json` (OUTSIDE this repo)

**Interfaces:**
- Consumes: `ai-light set <state> --source <name> [--ttl N]` from Tasks 1–3.
- Produces: nothing this repo depends on.

The wrapper holds all the Claude-specific knowledge — the hook stdin JSON shape
and the event→state mapping — so that `bin/ai-light` stays generic. It sits
beside the existing `agentpet.sh`, which already solves the same problem for an
on-screen pet; mirror its conventions.

Event mapping: `UserPromptSubmit` → `thinking`, `PreToolUse` → `working`,
`Notification` → `waiting`, `Stop` → `ready`.

Using the hook's `session_id` as the `--source` gives concurrent sessions
independent claims for free, and TTL expiry drops a killed session out of the
arbitration on its own.

- [ ] **Step 1: Write the hook wrapper**

Create `~/.claude/hooks/ai-light.sh`:

```sh
#!/bin/sh
# AI status light reporter for Claude Code hooks.
#
# Usage: ai-light.sh <state>     # state: thinking working waiting ready
#
# Translates a hook event into a claim on the shared status light. All the
# Claude-specific knowledge (stdin JSON shape, event mapping) lives here so that
# `ai-light` itself stays a generic tool.
#
# Fire-and-forget: never fails the hook.

state="$1"
input=$(cat 2>/dev/null)

# session_id (a standard hook stdin field) keys the claim, so concurrent
# sessions arbitrate against each other instead of overwriting one another. A
# session that dies simply lets its claim expire.
sid=$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null)
[ -n "$sid" ] || sid=default

# Notification fires both for "Claude needs your permission..." (a real
# call-to-action) and for "...waiting for your input" (just an idle turn). Only
# the former is `waiting`. Without this, an idle session would raise `waiting`,
# which outranks `working`, and would mask a genuinely busy session.
if [ "$state" = waiting ]; then
  notif=$(printf '%s' "$input" | jq -r '.message // empty' 2>/dev/null)
  case "$notif" in
    *permission* | *approve* | *confirm*) : ;;
    *) state=ready ;;
  esac
fi

# A long TTL on `waiting`: a permission prompt can sit unanswered for a while and
# the light must keep nagging. Everything else expires fast so a killed session
# releases the light quickly.
if [ "$state" = waiting ]; then
  ttl=900
else
  ttl=60
fi

"$HOME/.dotfiles/bin/ai-light" set "$state" --source "$sid" --ttl "$ttl" >/dev/null 2>&1 || true
exit 0
```

- [ ] **Step 2: Make it executable and test it by hand**

```bash
chmod +x ~/.claude/hooks/ai-light.sh
echo '{"session_id":"testsess"}' | ~/.claude/hooks/ai-light.sh working
~/.dotfiles/bin/ai-light status
```

Expected: `source testsess working normal 60` and `winner: working`; the light
is on.

Now check the idle-notification demotion:

```bash
echo '{"session_id":"testsess","message":"Claude is waiting for your input"}' | ~/.claude/hooks/ai-light.sh waiting
~/.dotfiles/bin/ai-light status
```

Expected: `winner: ready` — NOT `waiting`. Then the real call-to-action:

```bash
echo '{"session_id":"testsess","message":"Claude needs your permission to use Bash"}' | ~/.claude/hooks/ai-light.sh waiting
~/.dotfiles/bin/ai-light status
```

Expected: `winner: waiting`, ttl `900`. Clean up: `~/.dotfiles/bin/ai-light clear --source testsess`.

- [ ] **Step 3: Wire the four hooks into settings.json**

Edit `~/.claude/settings.json`. In the `hooks` object, add one command to each of
the four existing hook entries, beside the `agentpet.sh` command already there.
Each `hooks` array gains a second element:

- Under `Notification` → `{"type": "command", "command": "$HOME/.claude/hooks/ai-light.sh waiting"}`
- Under `UserPromptSubmit` → `{"type": "command", "command": "$HOME/.claude/hooks/ai-light.sh thinking"}`
- Under `Stop` → `{"type": "command", "command": "$HOME/.claude/hooks/ai-light.sh ready"}`
- Under `PreToolUse`, in the second (matcher-less) entry that already runs
  `agentpet.sh working` → `{"type": "command", "command": "$HOME/.claude/hooks/ai-light.sh working"}`

Do NOT add it to the first `PreToolUse` entry (the `Bash` matcher one, which runs
`rtk hook claude` and `gh-account-guard.sh`) — that would fire only on Bash calls.

Verify the file is still valid JSON:

```bash
jq empty ~/.claude/settings.json && echo "valid"
```

Expected: `valid`.

- [ ] **Step 4: Verify end-to-end in a real session**

Start a fresh Claude Code session in another terminal, send it a prompt that
uses a tool (e.g. "list the files in this directory"), and watch the light:

- On prompt submit → `thinking`
- During the tool call → `working`
- When it finishes → `ready`
- After 60s idle → `off` (the claim expires)

Also confirm `~/.dotfiles/bin/ai-light status` shows one source per live session
when two sessions run at once.

- [ ] **Step 5: Commit the repo side**

Only `bin/ai-light` and the spec/plan live in this repo; the hook wrapper and
settings.json are outside it and stay unversioned. Confirm nothing under
`~/.claude/` snuck in:

```bash
git status --short
```

Expected: clean, or only the plan/spec docs. If `bin/ai-light` still has
uncommitted changes from an earlier task, commit them now:

```bash
git commit -am "ai-light: wire up claude code hooks."
```

---

## Self-Review

**Spec coverage:**

| Spec requirement | Task |
|---|---|
| `set` / `clear` / `status` interface, defaults | 1 |
| Claim file format, one file per source | 1 |
| `off` ≡ clear | 1 |
| Six valid states | 1 |
| TTL expiry drops dead claims | 2 |
| Two priority tiers, `alert` > `normal` | 2 |
| Urgency order, no recency tiebreak | 2 |
| No live sources → `off` | 2 |
| Push only on change (`.last`) | 3 |
| `curl --max-time 1`, errors swallowed, never fails caller | 3 |
| `AI_LIGHT_HOST` override, no mDNS | 3 |
| Hook wrapper keyed by `session_id` | 4 |
| Idle-`Notification` demotion | 4 |
| Four hooks wired beside `agentpet.sh` | 4 |
| `~/.claude/` stays out of the repo | 4 |
| Generic client example (`make build \|\| ai-light set error ...`) | — documented in the spec; no code needed |

**Type consistency:** `compute_winner`, `push`, `urgency`, `tier`, `sanitize`,
`valid_state`, `cmd_set`, `cmd_clear`, `cmd_status` are named identically
everywhere they appear. The claim format `<state> <ttl> <priority> <mtime>` is
written in Task 1 and read in Tasks 1–2 with the same field order.

**Placeholder scan:** none — every step carries its full code and exact commands.
