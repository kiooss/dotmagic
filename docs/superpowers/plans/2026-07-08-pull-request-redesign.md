# pull-request Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite `bin/pull-request` from scratch as a simple, modern release-PR tool (`staging`/`production`/`init`) with git-config-driven branch/label names and no ticket-scraping legacy.

**Architecture:** Single bash script `bin/pull-request`. A subcommand dispatcher routes to `cmd_staging` / `cmd_production` / `cmd_init`. The two release commands share one `create_release_pr <base> <label>` helper that validates preconditions, resolves the current branch as head, runs `git up`, and calls `gh pr create --fill`. Config values are read via a `cfg <key> <default>` helper wrapping `git config --get`. Color output reuses the existing `bin/lib/colors.sh`.

**Tech Stack:** bash (macOS system bash 3.2-safe — no associative arrays), git, `gh` CLI (2.67), `bin/git-up`, `bin/lib/colors.sh`.

## Global Constraints

- Language: bash, macOS system bash 3.2-safe (no `declare -A`, no `mapfile`).
- `set -euo pipefail` at the top.
- Config keys (all under `pull-request.` section), read with `git config --get`, shell-side default via `${VAR:-default}`:
  - `pull-request.stagingBranch` default `staging`
  - `pull-request.prodBranch` default `production`
  - `pull-request.stagingLabel` default `staging-release`
  - `pull-request.prodLabel` default `production-release`
- head is ALWAYS the current branch (`git symbolic-ref --short HEAD`) — never hardcoded.
- Body generation is `gh pr create --fill` only — no ticket scraping, no `REF_BASE_URL`.
- Reuse `bin/lib/colors.sh` for color vars (`RED`/`GREEN`/`BLUE`/`CYAN`/`BOLD`/`ITALIC`/`NC`); source it the same way the old script did (`. "$DIR/lib/colors.sh"`).
- `git up` failure is non-fatal (warn, continue). All other validation failures exit non-zero with a `RED` message.
- Unknown/absent subcommand → usage to stderr, exit non-zero.
- Commit style: terse, lowercase.

---

### Task 1: Scaffold dispatcher, usage, colors, and config helper

**Files:**
- Create: `bin/pull-request`

**Interfaces:**
- Produces:
  - `usage()` — prints subcommand help to stderr.
  - `cfg <key> <default>` — echoes `git config --get pull-request.<key>` or `<default>` if unset/empty.
  - `die <msg>` — prints `${RED}msg${NC}` to stderr, exits 1.
  - Globals: `DIR` (script dir), color vars from `colors.sh`.
  - Dispatch on `$1`: `staging` | `production` | `init` | else usage+exit 1.
  - Stubs `cmd_staging` / `cmd_production` / `cmd_init` (filled in later tasks).

- [ ] **Step 1: Write the scaffold**

Create `bin/pull-request`:

```bash
#!/usr/bin/env bash
#
# pull-request — create staging / production release PRs.
#
#   pull-request staging      current branch -> staging branch, labeled
#   pull-request production   current branch -> production branch, labeled
#   pull-request init         create the two release labels (run once per repo)
#
# Branch and label names are configurable per-repo via git config
# (pull-request.stagingBranch / .prodBranch / .stagingLabel / .prodLabel);
# defaults are staging / production / staging-release / production-release.
#
# head is always the current branch. PR body is filled by `gh pr create --fill`.

set -euo pipefail

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/lib/colors.sh"

usage() {
  cat >&2 <<'EOF'
pull-request — create staging / production release PRs

Usage:
  pull-request staging       PR from current branch into the staging branch
  pull-request production    PR from current branch into the production branch
  pull-request init          create the staging/production release labels

Config (per-repo git config, with defaults):
  pull-request.stagingBranch  (staging)
  pull-request.prodBranch     (production)
  pull-request.stagingLabel   (staging-release)
  pull-request.prodLabel      (production-release)
EOF
}

# cfg <key> <default> — repo config value or default.
cfg() {
  local val
  val=$(git config --get "pull-request.$1" || true)
  echo "${val:-$2}"
}

die() {
  echo -e "${RED}$1${NC}" >&2
  exit 1
}

cmd_staging() { :; }     # Task 3
cmd_production() { :; }  # Task 3
cmd_init() { :; }        # Task 4

main() {
  local sub="${1:-}"
  [[ $# -gt 0 ]] && shift
  case "$sub" in
    staging)    cmd_staging "$@" ;;
    production) cmd_production "$@" ;;
    init)       cmd_init "$@" ;;
    *)          usage; exit 1 ;;
  esac
}

main "$@"
```

- [ ] **Step 2: Make executable**

Run: `chmod +x /Users/yang/.dotfiles/bin/pull-request`

- [ ] **Step 3: Verify dispatcher rejects unknown/absent subcommand**

Run: `/Users/yang/.dotfiles/bin/pull-request; echo "exit=$?"`
Expected: usage text to stderr, `exit=1`.

Run: `/Users/yang/.dotfiles/bin/pull-request bogus; echo "exit=$?"`
Expected: usage text, `exit=1`.

- [ ] **Step 4: Verify known subcommands dispatch (stubs, exit 0)**

Run: `/Users/yang/.dotfiles/bin/pull-request staging; echo "exit=$?"`
Expected: `exit=0` (stub no-op).

- [ ] **Step 5: Verify cfg helper reads config and falls back**

```bash
cd "$(mktemp -d)" && git init -q
/Users/yang/.dotfiles/bin/pull-request >/dev/null 2>&1 || true   # sanity
git config pull-request.stagingBranch release/stg
bash -c 'set -euo pipefail; DIR=/Users/yang/.dotfiles/bin; . "$DIR/lib/colors.sh";
  cfg() { local v; v=$(git config --get "pull-request.$1" || true); echo "${v:-$2}"; }
  echo "set=$(cfg stagingBranch staging)"; echo "default=$(cfg prodBranch production)"'
```
Expected: `set=release/stg` and `default=production`.

- [ ] **Step 6: Commit**

```bash
cd /Users/yang/.dotfiles
git add bin/pull-request
git commit -m "pull-request: scaffold dispatcher, cfg helper, usage."
```

---

### Task 2: Implement validation + shared `create_release_pr` helper

**Files:**
- Modify: `bin/pull-request` (add `validate_env`, `create_release_pr`)

**Interfaces:**
- Consumes: `cfg`, `die`, color vars.
- Produces:
  - `validate_env <base>` — dies unless: inside a git work tree; `gh` on PATH; HEAD is not detached; `<base>` exists as a local branch OR a remote-tracking ref. Returns 0 on success.
  - `create_release_pr <base> <label>` — validates, resolves head=current branch, runs `git up` (non-fatal), prints a colored summary, then `gh pr create --base "$base" --head "$head" --label "$label" --fill`.

- [ ] **Step 1: Add `validate_env` and `create_release_pr`**

Insert these functions above the `cmd_*` stubs:

```bash
validate_env() {
  local base=$1
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
    || die "Not inside a git repository."
  command -v gh >/dev/null 2>&1 \
    || die "gh CLI not found. Install it: brew install gh"
  git symbolic-ref --quiet HEAD >/dev/null 2>&1 \
    || die "Detached HEAD — check out a branch before creating a PR."
  # base must exist locally or as a remote-tracking branch.
  if ! git show-ref --verify --quiet "refs/heads/$base" \
    && ! git ls-remote --exit-code --heads origin "$base" >/dev/null 2>&1; then
    die "Base branch '$base' not found locally or on origin."
  fi
}

create_release_pr() {
  local base=$1
  local label=$2
  local head
  validate_env "$base"
  head=$(git symbolic-ref --short HEAD)

  echo -e "${BOLD}${ITALIC}${GREEN}git up${NC}\n"
  git up || echo -e "${RED}git up failed; continuing.${NC}"

  echo -e "${CYAN}=== Creating release PR ===${NC}"
  echo -e "  head:  ${ITALIC}${head}${NC}"
  echo -e "  base:  ${RED}${ITALIC}${base}${NC}"
  echo -e "  label: ${ITALIC}${label}${NC}\n"

  gh pr create --base "$base" --head "$head" --label "$label" --fill
  echo -e "${CYAN}=== done ===${NC}"
}
```

- [ ] **Step 2: Verify validation fails outside a git repo**

```bash
cd /tmp && rm -rf pr-novcs && mkdir pr-novcs && cd pr-novcs
bash -c 'set -euo pipefail; DIR=/Users/yang/.dotfiles/bin; . "$DIR/lib/colors.sh";
  die(){ echo -e "${RED}$1${NC}" >&2; exit 1; }
  validate_env(){ local base=$1; git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "Not inside a git repository."; }
  validate_env staging'; echo "exit=$?"
cd /tmp && rm -rf pr-novcs
```
Expected: `Not inside a git repository.` in red, `exit=1`.

Note: full `validate_env`/`create_release_pr` are exercised end-to-end in Task 3
(they're only reachable through `cmd_staging`/`cmd_production`). This step just
confirms the first guard fires; no commit-worthy behavior is testable in
isolation, so proceed to Task 3 before committing — OR commit now with the
partial helper since it's syntactically complete:

- [ ] **Step 3: Syntax check and commit**

Run: `bash -n /Users/yang/.dotfiles/bin/pull-request`
Expected: no output (valid).

```bash
cd /Users/yang/.dotfiles
git add bin/pull-request
git commit -m "pull-request: add env validation and shared PR creation helper."
```

---

### Task 3: Wire `staging` and `production` commands

**Files:**
- Modify: `bin/pull-request` (replace `cmd_staging` / `cmd_production` stubs)

**Interfaces:**
- Consumes: `cfg`, `create_release_pr`.
- Produces:
  - `cmd_staging` — `create_release_pr "$(cfg stagingBranch staging)" "$(cfg stagingLabel staging-release)"`.
  - `cmd_production` — `create_release_pr "$(cfg prodBranch production)" "$(cfg prodLabel production-release)"`.

- [ ] **Step 1: Implement the two commands**

Replace the stubs:

```bash
cmd_staging() {
  create_release_pr "$(cfg stagingBranch staging)" "$(cfg stagingLabel staging-release)"
}

cmd_production() {
  create_release_pr "$(cfg prodBranch production)" "$(cfg prodLabel production-release)"
}
```

- [ ] **Step 2: Verify detached-HEAD is rejected (validation reachable via cmd)**

```bash
sand=$(mktemp -d); cd "$sand"; git init -q
git config user.email t@t; git config user.name t
git commit -q --allow-empty -m init
git branch staging
git checkout -q --detach HEAD
/Users/yang/.dotfiles/bin/pull-request staging; echo "exit=$?"
cd /tmp && rm -rf "$sand"
```
Expected: `Detached HEAD — check out a branch before creating a PR.` in red, `exit=1`.

- [ ] **Step 3: Verify missing base branch is rejected**

```bash
sand=$(mktemp -d); cd "$sand"; git init -q
git config user.email t@t; git config user.name t
git commit -q --allow-empty -m init   # default branch, no 'staging'
/Users/yang/.dotfiles/bin/pull-request staging; echo "exit=$?"
cd /tmp && rm -rf "$sand"
```
Expected: `Base branch 'staging' not found locally or on origin.`, `exit=1`.
(This runs after the git-repo/gh/detached checks pass, so it also confirms
those three guards let a normal branch through.)

- [ ] **Step 4: Verify config override changes the resolved base**

```bash
sand=$(mktemp -d); cd "$sand"; git init -q
git config user.email t@t; git config user.name t
git commit -q --allow-empty -m init
git config pull-request.stagingBranch stg
/Users/yang/.dotfiles/bin/pull-request staging; echo "exit=$?"
cd /tmp && rm -rf "$sand"
```
Expected: error names `'stg'` (not `'staging'`) → config override works, `exit=1`.

- [ ] **Step 5: Commit**

```bash
cd /Users/yang/.dotfiles
git add bin/pull-request
git commit -m "pull-request: implement staging and production commands."
```

---

### Task 4: Implement `init` (label creation)

**Files:**
- Modify: `bin/pull-request` (replace `cmd_init` stub)

**Interfaces:**
- Consumes: `cfg`.
- Produces: `cmd_init` — creates the staging and production release labels via `gh label create` using the configured label names.

- [ ] **Step 1: Implement `cmd_init`**

Replace the stub:

```bash
cmd_init() {
  command -v gh >/dev/null 2>&1 || die "gh CLI not found. Install it: brew install gh"
  gh label create "$(cfg stagingLabel staging-release)" -f -d "Staging release" -c "#0052CC"
  gh label create "$(cfg prodLabel production-release)" -f -d "Production release" -c "#B60205"
}
```

- [ ] **Step 2: Verify init fails cleanly without gh (guard reachable)**

```bash
# Simulate gh missing by running the guard in a PATH without gh.
bash -c 'set -euo pipefail; DIR=/Users/yang/.dotfiles/bin; . "$DIR/lib/colors.sh";
  die(){ echo -e "${RED}$1${NC}" >&2; exit 1; }
  command -v gh >/dev/null 2>&1 || die "gh CLI not found. Install it: brew install gh"
  echo "gh present"' 
```
Expected: since gh IS installed here, prints `gh present`. (The guard line is
identical to the validated one in Task 2; no gh-less environment is available
to test the failure branch, so this confirms the happy path only. Note this
limitation.)

- [ ] **Step 3: Syntax check and commit**

Run: `bash -n /Users/yang/.dotfiles/bin/pull-request`
Expected: valid.

```bash
cd /Users/yang/.dotfiles
git add bin/pull-request
git commit -m "pull-request: implement init label creation."
```

---

### Task 5: End-to-end smoke test in a throwaway repo (no real PR)

**Files:** none (verification only).

**Interfaces:** Consumes the finished `bin/pull-request`.

- [ ] **Step 1: Full happy-path up to the gh call**

Build a throwaway local repo with a `staging` branch and a feature branch, then
confirm the script passes all validation and reaches the `gh pr create` step.
Since there is no real remote/PR, expect the failure to be from `gh` (no auth
for this fake repo / no remote), NOT from our validation — proving our code did
its whole job.

```bash
sand=$(mktemp -d); cd "$sand"; git init -q
git config user.email t@t; git config user.name t
git commit -q --allow-empty -m init
git branch staging
git checkout -q -b feature
# git up will fail (no upstream) but must be non-fatal; validation must pass;
# gh will fail at the create step (no remote) — that's expected here.
/Users/yang/.dotfiles/bin/pull-request staging; echo "exit=$?"
cd /tmp && rm -rf "$sand"
```
Expected: output shows the `git up` line (with a non-fatal failure notice), the
colored `=== Creating release PR ===` summary with head=`feature` base=`staging`
label=`staging-release`, then a `gh`-originated error (not one of our `die`
messages). This confirms head resolution, config defaults, non-fatal git-up, and
that control reaches `gh pr create`.

- [ ] **Step 2: Confirm no leftover artifacts / working tree clean**

```bash
cd /Users/yang/.dotfiles && git status --short
```
Expected: only expected `bin/pull-request` already committed; no stray files.

- [ ] **Step 3: (No commit — verification only.)**

---

## Notes for the implementer

- **bash 3.2:** no associative arrays; this plan uses none. `local` inside
  functions is fine in 3.2.
- **`set -e` + `cfg`:** `git config --get` exits 1 when a key is unset. The
  `|| true` in `cfg` prevents that from killing the script under `set -e`.
- **`git up` non-fatal:** it's `git up || echo ...` so a missing upstream (common
  in throwaway test repos) does not abort PR creation.
- **Don't create real PRs during verification.** Every test uses a throwaway
  `mktemp -d` repo with no real remote; the only place a real `gh pr create`
  would fire is against a repo you actually intend to release. The Task 5 smoke
  test deliberately lets `gh` fail at the network step.
- **colors.sh dependency:** the script sources `$DIR/lib/colors.sh`. When run via
  the symlinked `~/bin` path or directly from `bin/`, `$DIR` resolves to the
  `bin/` dir so `lib/colors.sh` is found — same mechanism the old script used.
