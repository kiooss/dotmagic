# DOTMAGIC

```sh
 _    _                           _       _    __ _ _
| | _(_) ___   ___  ___ ___    __| | ___ | |_ / _(_) | ___  ___
| |/ / |/ _ \ / _ \/ __/ __|  / _` |/ _ \| __| |_| | |/ _ \/ __|
|   <| | (_) | (_) \__ \__ \ | (_| | (_) | |_|  _| | |  __/\__ \
|_|\_\_|\___/ \___/|___/___/  \__,_|\___/ \__|_| |_|_|\___||___/
```

> My personal dotfiles for macOS.

Editor is [Neovim](https://neovim.io), shell is zsh + [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh),
multiplexer is [tmux](https://github.com/tmux/tmux). Terminal is [Ghostty](https://ghostty.org)
or [kitty](https://sw.kovidgoyal.net/kitty/).

There is no build step — deploy is a symlink farm into `$HOME` plus a
Homebrew install pass.

## Install

```sh
git clone https://github.com/kiooss/dotmagic.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive
brew bundle --file=Brewfile   # macOS packages (installs Homebrew deps)
bin/dotlink sync              # symlink configs into $HOME and ~/.config
```

Language toolchains (rbenv, pyenv, oh-my-zsh) are not auto-installed — install
them as needed; `rbenv`/`ruby-build` are already in the `Brewfile`.

## Upgrade

```sh
cd ~/.dotfiles
git pull --rebase --autostash origin master
git submodule update --init --recursive
```

The `upgrade_dotfiles` zsh function (from `dotconfig/zsh/lib/functions.zsh`)
runs these two steps for you.

## Linking

`bin/dotlink` is the symlink engine:

- `dotlink sync [--force]` — link all configs into `$HOME` and `~/.config`
- `dotlink add <tool> [--mac]` — adopt an existing `~/.config/<tool>/` into the repo
- `dotlink unlink <tool>` — move it back out

## License

[MIT](LICENSE)
