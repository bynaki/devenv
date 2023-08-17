# Essential Development Environment on MacOS

Created: August 9, 2023 11:37 PM

## Install Command Line Developer Tools & Git

[Git](https://git-scm.com/)

- type ‘git’ in terminal to install it

## Install Homebrew

[Homebrew](https://brew.sh/)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Generate a new SSH key

[Generating a new SSH key and adding it to the ssh-agent - GitHub Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

## Add a new SSH key to your GitHub account

[Adding a new SSH key to your GitHub account - GitHub Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

## **Environment Variable**

```bash
export DEVENV="$HOME/devenv"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
mkdir "$HOME/.config"
mkdir -p "$HOME/.local/share"
```

## Clone DevEnv Git Repository

```bash
git clone [https://github.com/bynaki/devenv.git](https://github.com/bynaki/devenv.git) $DEVENV
```

## Git Configure Symbolic Link

```bash
ln -sf $DEVENV/.gitconfig ~/.gitconfig
```

## Install Nerd Fonts

[Nerd Fonts - Iconic font aggregator, glyphs/icons collection, & fonts patcher](https://www.nerdfonts.com/)

- they are `$DEVENV/fonts`
- I recommend `$DEVENV/fonts/JetBrains-Mono/Complete`

## Install ripgrep

[https://github.com/BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)

> It’s necessary for Neovim.
> 

```bash
brew install ripgrep
```

## Install Alacritty

[Alacritty - A cross-platform, OpenGL terminal emulator](https://alacritty.org/)

```bash
brew install --cask alacritty
mkdir $XDG_CONFIG_HOME/alacritty
ln -sf $DEVENV/config/alacritty/macos.yml $XDG_CONFIG_HOME/alacritty/alacritty.yml
```

## Install Hammerspoon

[Hammerspoon](http://www.hammerspoon.org/)

```bash
brew install --cask hammerspoon
ln -sf $DEVENV/hammerspoon ~/.hammerspoon
```

## Install Visual Studio Code

[Visual Studio Code](https://code.visualstudio.com/)

```bash
brew install --cask visual-studio-code
code
ln -sf $DEVENV/vscode/naki-theme $HOME/.vscode/extensions
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```