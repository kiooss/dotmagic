# tmux + fzf URL picker — design

## Goal

Pick a URL off the current tmux pane and open it in the browser, driven by
`fzf` in a popup. Fits the existing dotfiles conventions: a `bin/tmux-*`
helper script plus a `prefix`-keyed `display-popup` binding, mirroring the
session picker already bound to `prefix G`.

## Behavior

- **Trigger:** `prefix + u` (currently unbound; `u` = url).
- **Source:** the visible pane only — `tmux capture-pane -p` of the pane the
  binding was launched from. No scrollback scan.
- **Action:** open each chosen URL in the default browser (`open` on macOS,
  `xdg-open` on Linux). No clipboard path.
- **Selection:** `fzf --multi`, so several URLs can be tab-selected and opened
  at once. Pressing Enter with nothing multi-selected opens the highlighted row.
- **Ordering:** most-recent-first — reverse the captured lines so URLs near the
  bottom of the screen sort to the top of the list. Dedup while preserving that
  order (first occurrence wins).
- **Empty case:** if no URLs are found, print `no URLs` and exit 0; the popup
  closes on the next keypress.

## Components

### `bin/tmux-url-fzf`

Shell script (`#!/usr/bin/env bash`), sibling to `bin/tmux-public-ip`,
`bin/tmux-weather`, etc. Takes one argument: the target pane id.

Steps:

1. `pane="${1:?pane id required}"`.
2. Capture visible pane: `tmux capture-pane -p -J -t "$pane"`
   (`-J` joins wrapped lines so a URL split across the wrap is recovered).
3. Extract URLs with `grep -oE`:
   - match `https?://[^[:space:]]+`
   - also match bare `www\.[^[:space:]]+` and prefix `https://` onto those.
4. Strip common trailing punctuation so URLs pasted mid-sentence come out
   clean: trailing `,.;:!?` and unbalanced closing `)]}>"'`.
5. Reverse (`tail -r` on macOS / fallback) and dedup preserving order
   (awk `!seen[$0]++`).
6. If the result is empty, echo `no URLs` and exit 0.
7. Pipe into `fzf --multi --prompt='url> '` with a preview window echoing the
   full line (helps when the list is truncated).
8. For each selected line, open it:
   - macOS (`uname` = Darwin) → `open "$url"`
   - else → `xdg-open "$url"`

Opener is resolved once via a small `case "$(uname)"` block.

### tmux.conf binding

Added in the bindings block, near the existing `prefix G` session picker:

```tmux
bind -N "Pick a URL from the pane with fzf" \
  u display-popup -E -b none -w 80% -h 40% \
    "~/.dotfiles/bin/tmux-url-fzf '#{pane_id}'"
```

`#{pane_id}` is expanded by tmux before the popup opens, so the script captures
the pane the user launched from — not the popup's own pane.

## Non-goals

- No scrollback / full-history scan (visible pane only).
- No clipboard action (browser-open only).
- No configuration knobs; conventions are hard-coded to match the repo style.

## Verification

Manual, since the repo has no test harness:

1. `tmux source-file ~/.config/tmux/tmux.conf` (or `prefix r`).
2. In a pane, `echo`/`cat` some text containing a couple of URLs.
3. `prefix u` → popup with fzf list, most-recent URL on top.
4. Enter → URL opens in the browser; popup closes.
5. Tab-select two, Enter → both open.
6. Run in a pane with no URLs → `no URLs`, popup closes on keypress.
