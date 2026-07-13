# AI Status Light — design

Date: 2026-07-13

## What this is

A physical LAN status light (ESP-class board, HTTP-controlled) is to become a
general-purpose ambient status indicator that any tool can push state to —
Claude Code sessions, long builds, CI results, ad-hoc scripts.

The device exposes one endpoint:

    GET http://<host>/state?value=<ready|thinking|working|waiting|error|off>

## Why arbitration is the whole problem

Lighting the bulb is one `curl`. The design problem is that there is exactly
one bulb and many pushers:

- Claude Code's `PreToolUse` hook fires on *every* tool call. Left alone it
  floods the light and drowns out everything else.
- A crashed or killed session never sends a terminal state, so the light gets
  stuck on `working` forever. A physical light stuck in the wrong state is
  worse than a dark one.
- Several Claude sessions run concurrently. The one blocked on a permission
  prompt (`waiting`) is the one worth surfacing, even if another is busily
  `working`.

So the deliverable is an arbiter, not a relay.

## Scope decision

The light is a **general** indicator, not a Claude Code peripheral. Anything
that can exec a command can push to it. Claude Code is one client among
several, and `bin/ai-light` must not know Claude Code exists.

(An existing pipeline, `~/.claude/hooks/agentpet.sh` → `localhost:17321`,
already collapses concurrent Claude sessions for an on-screen pet. Routing the
light through that server was rejected: it would make every other tool speak
AgentPet's HTTP API and depend on that server being alive, which contradicts
the general-indicator goal.)

## Architecture

One shell script, `bin/ai-light`. No daemon, no new service.

### Interface

    ai-light set <state> [--source NAME] [--ttl SECONDS] [--priority alert]
    ai-light clear [--source NAME]
    ai-light status

- `<state>` ∈ `ready thinking working waiting error off`
- `--source` — who is speaking. Default `default`.
- `--ttl` — seconds this claim stays valid. Default 60.
- `--priority` — `normal` (default) or `alert`.

`off` is not a colour, it is "I have nothing to say": it is equivalent to
`clear` for that source.

### State store

One file per source: `/tmp/ai-light/<source>`, holding a single line

    <state> <ttl> <priority> <mtime-epoch>

### Arbitration (recomputed in-process on every call)

1. Read every source file; discard any where `now - mtime > ttl`.
2. Winner = highest priority tier, then highest state urgency
   (`error > waiting > working > thinking > ready`), then most recently written.
3. No live sources → `off`.
4. If the winner equals the value in `/tmp/ai-light/.last`, **send nothing**.

Step 4 is what makes the high-frequency Claude hook affordable: ten consecutive
`Bash` tool calls produce one HTTP request, and nine pure-local file reads. The
light is never spammed and the hook is never slowed.

### Priority model

Two tiers, deliberately not a free numeric scale — a numeric scale is
unmemorable three months later.

- `normal` — the ambient session stream (Claude's thinking/working/waiting).
- `alert` — "actually look up": build failed, tests finished, deploy done.
  Beats any `normal` claim until its TTL expires or it is cleared.

### Transport

    curl -s --max-time 1 "http://$AI_LIGHT_HOST/state?value=$winner" || true

Fire-and-forget with a short timeout, errors swallowed, never fails the caller.
An unplugged light must not break a hook or a build. (Same discipline as the
proven `agentpet.sh`.)

### Host configuration

`AI_LIGHT_HOST` env var, defaulting to the device's LAN IP baked into the
script. mDNS (`ai-light.local`) was rejected: resolution latency lands on
*every* Claude tool call, and this path must stay effectively free.

## Claude Code integration

A thin wrapper, `~/.claude/hooks/ai-light.sh`, sits beside the existing hook
scripts. It reads the hook JSON on stdin, extracts `session_id`, and calls
`ai-light set <state> --source "$session_id"`. It is added alongside
`agentpet.sh` on the four existing hooks (`UserPromptSubmit` → thinking,
`PreToolUse` → working, `Notification` → waiting, `Stop` → ready).

`Notification` fires both for a real "needs your permission" call-to-action and
for a plain "waiting for your input" idle turn. Only the former maps to
`waiting`; the idle case maps to `ready`. (`agentpet.sh` already discriminates
these by matching the notification text — reuse that test.) Without this, an
idle notification would raise `waiting`, which outranks `working`, and one idle
session would mask a genuinely busy one.

Using `session_id` as the source name gives concurrent sessions independent
claims for free, and TTL expiry means a killed session drops out of the
arbitration on its own after 60s — the light recovers without anyone sending a
terminal state.

The Claude-specific knowledge (stdin JSON shape, event→state mapping) lives
entirely in this wrapper. `bin/ai-light` stays generic.

## Other clients

    make build || ai-light set error --source build --ttl 300 --priority alert

## Repo boundary

`~/.claude/` is currently not tracked by dotfiles. This work does not change
that: `bin/ai-light` goes into the dotfiles repo, the hook wrapper is written
directly into `~/.claude/hooks/` and stays unversioned. Bringing `.claude`
under dotfiles management is a separate piece of work.

## Constraints

- macOS system shell is bash 3.2 — no `declare -A`. Write POSIX `sh`, matching
  the style of `bin/gh-active-user`.
- No test suite exists in this repo. Verification is manual: `ai-light status`
  plus watching the bulb.
