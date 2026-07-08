# DOTMAGIC

```sh
 _    _                           _       _    __ _ _
| | _(_) ___   ___  ___ ___    __| | ___ | |_ / _(_) | ___  ___
| |/ / |/ _ \ / _ \/ __/ __|  / _` |/ _ \| __| |_| | |/ _ \/ __|
|   <| | (_) | (_) \__ \__ \ | (_| | (_) | |_|  _| | |  __/\__ \
|_|\_\_|\___/ \___/|___/___/  \__,_|\___/ \__|_| |_|_|\___||___/
```

> My personal dotfiles for macOS and Ubuntu.

Editor is [Neovim](https://neovim.io), shell is zsh + [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh),
multiplexer is [tmux](https://github.com/tmux/tmux). Terminal is [Ghostty](https://ghostty.org)
or [kitty](https://sw.kovidgoyal.net/kitty/).

There is no build step — deploy is a symlink farm into `$HOME` plus a
Homebrew/apt install pass.

## Install

Via git:

```sh
git clone https://github.com/kiooss/dotmagic.git ~/.dotfiles
bash ~/.dotfiles/bin/dotmagic
```

Via curl:

```sh
curl -fsSL https://raw.githubusercontent.com/kiooss/dotmagic/master/bin/dotmagic | bash
```

`bin/dotmagic` pulls the latest, syncs submodules, optionally runs the per-OS
installer, and links everything into place.

## Upgrade

Run `dotmagic` from anywhere on `PATH` to update an existing checkout.

## Linking

`bin/dotlink` is the symlink engine:

- `dotlink sync [--force]` — link all configs into `$HOME` and `~/.config`
- `dotlink add <tool> [--mac]` — adopt an existing `~/.config/<tool>/` into the repo
- `dotlink unlink <tool>` — move it back out

## License

[MIT](LICENSE)
