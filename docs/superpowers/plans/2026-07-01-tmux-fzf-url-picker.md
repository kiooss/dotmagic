# tmux + fzf URL picker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `prefix + u` tmux binding that pops up an fzf picker of URLs on the current pane and opens the chosen one(s) in the browser.

**Architecture:** One `bin/tmux-url-fzf` shell script does capture → extract → dedup → fzf → open. A single `bind` line in `tmux.conf` launches it inside a `display-popup`, passing the launching pane's id so the script captures the right pane.

**Tech Stack:** bash, tmux (`capture-pane`, `display-popup`), `fzf`, `grep -oE`, `awk`; `open` (macOS) / `xdg-open` (Linux) as the opener.

## Global Constraints

- Source: **visible pane only** — `tmux capture-pane -p -J`. No scrollback scan.
- Action: **open in browser only** — no clipboard path.
- Ordering: most-recent-first (reverse captured lines), dedup preserving first occurrence.
- Empty result: print `no URLs`, exit 0.
- Selection: `fzf --multi`; Enter with no multi-select opens the highlighted row.
- Script lives at `bin/tmux-url-fzf`, sibling to `bin/tmux-public-ip` / `bin/tmux-weather`; `#!/usr/bin/env bash`, `chmod +x`.
- Binding: `prefix + u`, via `display-popup -E -b none`, matching the `prefix G` session picker style. Pass `#{pane_id}`.
- Commit style: terse, lowercase (e.g. `add tmux url picker.`).

---

### Task 1: The `tmux-url-fzf` script

**Files:**
- Create: `bin/tmux-url-fzf`

**Interfaces:**
- Consumes: `$1` = tmux target pane id (e.g. `%3`), passed by the tmux binding.
- Produces: an executable script invoked as `tmux-url-fzf '<pane_id>'`; opens selected URLs in the browser, prints `no URLs` when none found.

- [ ] **Step 1: Write the script**

Create `bin/tmux-url-fzf` with exactly this content:

```bash
#!/usr/bin/env bash
# Pick a URL from a tmux pane's visible content with fzf and open it.
# Usage: tmux-url-fzf <pane_id>
set -euo pipefail

pane="${1:?pane id required}"

# Resolve the browser opener once.
case "$(uname)" in
  Darwin) opener="open" ;;
  *)      opener="xdg-open" ;;
esac

# Capture the visible pane (-J joins wrapped lines so split URLs survive),
# pull out URLs, promote bare www. hosts, strip trailing punctuation,
# reverse to most-recent-first, and dedup preserving order.
urls="$(
  tmux capture-pane -p -J -t "$pane" \
    | grep -oE '(https?://|www\.)[^[:space:]]+' \
    | sed -E 's#^www\.#https://www.#' \
    | sed -E 's#[],.;:!?"'"'"'>)}]+$##' \
    | awk 'NF' \
    | tail -r \
    | awk '!seen[$0]++'
)"

if [ -z "$urls" ]; then
  echo "no URLs"
  exit 0
fi

selected="$(printf '%s\n' "$urls" \
  | fzf --multi --prompt='url> ' \
        --preview='echo {}' --preview-window=down:3:wrap)" || exit 0

[ -z "$selected" ] && exit 0

while IFS= read -r url; do
  [ -n "$url" ] && "$opener" "$url"
done <<< "$selected"
```

Notes for the implementer:
- `tail -r` reverses lines on macOS/BSD (this repo is macOS-primary; other `bin/tmux-*` scripts assume macOS). On GNU-only systems `tac` is the equivalent, but do **not** add fallback logic unless testing on Linux fails — YAGNI.
- The `sed` trailing-strip class is `],.;:!?"'>)}` — order matters only in that `]` is first inside the bracket expression so it's treated as a literal.
- fzf exiting non-zero (Esc / no match) is swallowed by `|| exit 0` so the popup closes cleanly.

- [ ] **Step 2: Make it executable**

Run: `chmod +x ~/.dotfiles/bin/tmux-url-fzf`
Expected: no output, exit 0.

- [ ] **Step 3: Verify extraction logic without tmux**

Run:
```bash
printf 'see https://example.com/a, and www.foo.org.\nhttps://example.com/a again\n' \
  | grep -oE '(https?://|www\.)[^[:space:]]+' \
  | sed -E 's#^www\.#https://www.#' \
  | sed -E 's#[],.;:!?"'"'"'>)}]+$##' \
  | awk 'NF' | tail -r | awk '!seen[$0]++'
```
Expected output (most-recent-first, deduped, punctuation trimmed):
```
https://example.com/a
https://www.foo.org
```

- [ ] **Step 4: Commit**

```bash
cd ~/.dotfiles
git add bin/tmux-url-fzf
git commit -m "add tmux url picker script."
```

---

### Task 2: The tmux binding

**Files:**
- Modify: `dotconfig/tmux/tmux.conf` (bindings block, near the `prefix G` session picker around line 202-205)

**Interfaces:**
- Consumes: `bin/tmux-url-fzf` from Task 1.
- Produces: `prefix + u` opens the picker popup.

- [ ] **Step 1: Add the binding**

In `dotconfig/tmux/tmux.conf`, immediately after the `prefix P` popup binding (the `bind -N "Create a new popup."` block, ~line 204-205), add:

```tmux
bind -N "Pick a URL from the pane with fzf" \
  u display-popup -E -b none -w 80% -h 40% \
    "~/.dotfiles/bin/tmux-url-fzf '#{pane_id}'"
```

- [ ] **Step 2: Reload tmux config**

Run: `tmux source-file ~/.config/tmux/tmux.conf`
Expected: no error output (config parses cleanly).

- [ ] **Step 3: Manual end-to-end verification**

Do the following in a tmux pane:
1. `printf 'go to https://example.com and www.google.com\n'`
2. Press `prefix u` (prefix is `C-Space`).
   Expected: a centered popup with an fzf list showing `https://example.com` and `https://www.google.com`, most-recent on top.
3. Highlight one, press Enter.
   Expected: URL opens in the default browser; popup closes.
4. `prefix u` again, `Tab` to multi-select both, Enter.
   Expected: both open.
5. In a pane with no URLs on screen, `prefix u`.
   Expected: popup shows `no URLs`; closes on keypress.

- [ ] **Step 4: Commit**

```bash
cd ~/.dotfiles
git add dotconfig/tmux/tmux.conf
git commit -m "bind prefix-u to url picker."
```

---

## Self-Review

**Spec coverage:**
- Trigger `prefix + u` in popup → Task 2. ✓
- Visible pane only (`capture-pane -p -J`) → Task 1 Step 1. ✓
- Open in browser (`open`/`xdg-open`) → Task 1 opener block. ✓
- `--multi`, Enter-on-highlight → Task 1 fzf invocation. ✓
- Most-recent-first + dedup → `tail -r | awk '!seen[$0]++'`. ✓
- Empty → `no URLs`, exit 0 → Task 1. ✓
- Trailing-punctuation strip → Task 1 `sed`. ✓
- `#{pane_id}` passed so popup captures launching pane → Task 2. ✓

**Placeholder scan:** none — full script and binding text are inline.

**Type consistency:** script name `tmux-url-fzf` and argument (`pane_id`) are used identically in Task 1 and Task 2. ✓
