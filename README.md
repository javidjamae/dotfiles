# Overview

I use Mac with Homebrew. Here are my dotfiles and other useful info
about how I set up my machine / environment.

# Installation

1) Clone this repository into your `~` directory.

2) Run `./install.sh`, which will:
- Copy the existing dotfiles in `~` into a folder called `~/dotfiles_old`
- Create new symlinks for all the dotfiles in `~` that point to the files in `~/dotfiles`

3) Restart your terminal

# Homebrew

Here is a list of libraries that I commonly use (some of these are
required for the dotfiles to work).

## Docker
- `brew cask install docker`
- `brew install docker-compose`

## Git
- `brew install git`
- `brew install tig`
- `brew install bash-git-prompt`

## Javascript
- `brew install yarn`

## Terminal / Bash
- `brew install thefuck`
- `brew install iterm2`
- `brew install bash-completion`

## Vim
- `brew install macvim`

# Janus

I use the [Janus](https://github.com/carlhuda/janus) distribution to manage all my vim
plugins. Install macvim using brew, then follow the Janus installation instructions.

# Keyboard Mappings

I make `Caps Lock` behave as `Control` to make vim easier to work with.

System Preferences -> Keyboard -> Keyboard -> Modifier Keys
- Caps Lock ==> ^ Control
