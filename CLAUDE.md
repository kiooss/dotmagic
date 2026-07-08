# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles ("DOTMAGIC", `kiooss/dotmagic`) for macOS. Editor is Neovim, shell is zsh + oh-my-zsh, multiplexer is tmux. There is no build/test step — the "deploy" is a symlink farm into `$HOME` (via `bin/dotlink sync`) plus a `brew bundle` install pass.

## Top-level layout (only the non-obvious bits)

- Setup is manual (no bootstrap script): clone, `git submodule update --init --recursive`, `brew bundle --file=Brewfile`, then `bin/dotlink sync`. Update with `git pull --rebase --autostash` (the `upgrade_dotfiles` zsh function wraps this).
- `bin/dotlink` — the symlink engine (subcommands: sync / add / unlink). It scans three roots and links into `$HOME`:
  - `link/*.symlink` → `~/.<basename-without-symlink>` (e.g. `link/zshenv.symlink` → `~/.zshenv`)
  - `dotconfig/<name>/` → `~/.config/<name>/` (cross-platform XDG configs)
  - `config.mac/<name>/` → `~/.config/<name>/` (macOS-only, skipped on Linux)
  Pass `--force` to back up existing real files into `~/.backup/` before relinking. Without `--force`, existing non-symlink files are skipped with a warning. `dotlink add <tool> [--mac]` adopts an existing `~/.config/<tool>/` into `dotconfig/` (or `config.mac/` with `--mac`); `dotlink unlink <tool>` reverses it.
- `Brewfile` — declarative Homebrew bundle (taps + brews + casks), the single source of truth for packages. Apply with `brew bundle --file=Brewfile`.
- `zsh/omz_custom/` — oh-my-zsh customizations (plugins + powerlevel10k theme are git submodules).
- `vendor/` — third-party code pulled as git submodules (see `.gitmodules`).
- `hammerspoon/` — Hammerspoon Lua config; linked to `~/.hammerspoon/` separately by the user (not handled by `dotlink sync`).

## Working with symlinked configs

Files under `dotconfig/`, `config.mac/`, and `link/` are **hardlinked or symlinked** into `$HOME` after `dotlink sync` runs. Editing the repo file edits the live config in-place — there is no copy step. To verify a file is actually live: `stat -f '%i' <repo-path> <home-path>` and compare inodes, or `readlink ~/.config/<name>`.

After editing a tool's config, reload that tool — do not assume a shell restart picks it up:

| Tool | Reload command |
|---|---|
| AeroSpace (`config.mac/aerospace/aerospace.toml`) | `aerospace reload-config` (exits non-zero on TOML/binding errors — use as a validator) |
| Karabiner-Elements (`config.mac/karabiner/karabiner.json`) | Auto-reloads on file change. JSON is sensitive — edit via Python/jq, not freehand. When rewriting the whole file, dump with `json.dump(d, f, indent=2, ensure_ascii=False)` + a trailing `\n` — the file is 2-space-indented with literal (non-escaped) unicode, so `indent=4` or default `ensure_ascii=True` reformats every line and produces a multi-thousand-line diff for a one-line change. |
| Hammerspoon (`hammerspoon/*.lua`) | Menubar → Reload Config. IPC (`hs -c …`) is usually **disabled**, so remote reload from a shell returns exit 69 — ignore. |
| tmux (`dotconfig/tmux/`) | `tmux source-file ~/.config/tmux/tmux.conf` or `prefix-r` if bound. |
| Neovim (`dotconfig/nvim/`) | Restart nvim; plugin changes need `:Lazy sync`. |

## Modifier-key topology (important context for any keybinding edit)

Three layers cooperate, in this order:

1. **Karabiner** (`config.mac/karabiner/karabiner.json`)
   - `caps_lock` → `left_control`
   - `right_control` → Hyper, emitted as `cmd+alt+ctrl` (held)
   - `application` and `scroll_lock` → `fn`
   - Other complex rules: Space→`,Esc/Ctrl-[ → eisuu (IME toggle), right-shift+letter app launcher, etc.
2. **AeroSpace** (`config.mac/aerospace/aerospace.toml`) — owns all `cmd-alt-ctrl-<key>` bindings (workspace switch, focus, move, app launch via `exec-and-forget`). `cmd-alt-ctrl-shift-<key>` is the "with shift" variant.
3. **Hammerspoon** (`hammerspoon/init.lua`) — handles non-Hyper bindings only (cmd+arrows for clipboard/audio, cmd+shift+letters for focus/clipboard, etc.). The old `hyper.lua` modal is no longer wired in but the file remains for re-enabling.

When adding an AeroSpace binding, search for the key first — `cmd-alt-ctrl-comma` already means `layout accordion`, for example. App launchers live under the workspace bindings as a labeled block.

## Git workflow notes

- Commit messages in this repo are intentionally terse and lowercase (`update.`, `install cargo.`, `disable markdownlint.`). Match that style — don't write multi-paragraph commits unless the change really warrants it.
- The repo has **submodules**. After cloning, run `git submodule update --init --recursive`.
- Several config files are gitignored because they hold local secrets/state — `hammerspoon/local_config.lua`, `hammerspoon/private.lua`, `dotconfig/zsh/.zshrc.local`, `config.mac/karabiner/.env`. Do not commit examples that overwrite these.

## What this repo is *not*

- No test suite, no CI, no linter beyond `.editorconfig` (2-space indent, tab for `*.snippets`). Do not invent commands like `npm test` or `make lint` — they don't exist.
- No package metadata (`package.json`, `Cargo.toml` at root, etc.). The only manifest is `Brewfile`.
