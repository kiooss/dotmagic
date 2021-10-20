# DOTMAGIC

```sh
 _    _                           _       _    __ _ _
| | _(_) ___   ___  ___ ___    __| | ___ | |_ / _(_) | ___  ___
| |/ / |/ _ \ / _ \/ __/ __|  / _` |/ _ \| __| |_| | |/ _ \/ __|
|   <| | (_) | (_) \__ \__ \ | (_| | (_) | |_|  _| | |  __/\__ \
|_|\_\_|\___/ \___/|___/___/  \__,_|\___/ \__|_| |_|_|\___||___/
```

> Manage my dotfiles (for personal use).

Basicly tested on OSX / Ubuntu, but some configuration like
(**vim**/**zsh**/**tmux**) should be able to migrate to other os distribution easily.

I use vim as my editor, zsh as my shell, and tmux as my terminal multiplexer.

## The Purpose

**Automate All The Things!**

When I am in a new machine, I'd like to build my enviroment from zero over just
copy from existed enviroment (which may cause a lot of wired problems).

## Install

Install is quite easy, just follow the steps below.

Via git

```sh
git clone https://github.com/kiooss/dotmagic.git ~/.dotfiles
bash ~/.dotfiles/bin/dotmagic
```

Via curl

```sh
curl -fsSL https://raw.github.com/kiooss/dotmagic/master/bin/dotmagic | bash
```

## Upgrade

You just need to run:

```sh
dotmagic
```

## Vim

Now on neovim 0.5.
Note: the configuration is always WIP state.

## Zsh

My own config plus [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).
Oh-my-zsh is optional, but it does a lot things for me and worked well, so I add
it to my config.

## Tmux

Tmux is awesome, it saves me a lot of time since I decided to use it.

## License

[MIT](license)

