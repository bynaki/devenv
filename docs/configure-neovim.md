# Configure Neovim

Created: August 11, 2023 10:05 PM

## Neovim Home

[Home - Neovim](https://neovim.io/)

## Install Neovim

**on Mac:**

```bash
brew install neovim
```

**on Arch Linux:**

```bash
sudo pacman -S neovim
```

## Configure Symbolic Link

```bash
ln -sf $DEVENV/config/nvim $XDG_CONFIG_HOME/nvim
```

## Install Packer

[https://github.com/wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

> Plugin/package management for Neovim.
> 

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

**Install Plugins In Neovim:**

```bash
:PackerInstall
```