# DevEnv


## Essential

### Docker Run (on M1(arm) 이지만 amd64 아키텍쳐로)

```bash
docker run -it --name "devenv-arch" --platform linux/amd64 archlinux
```

### **Initialize keyring & Update**

[How to Setup | Arch WSL official documentation](https://www.notion.so/How-to-Setup-Arch-WSL-official-documentation-a0e2b2f9edd74ca9bb619c518a745e36)

Please excute these commands to initialize the keyring. (This step is necessary to use pacman.)

```bash
pacman-key --init
pacman-key --populate
pacman -Sy archlinux-keyring
pacman -Su
```

### Install Sudo

```bash
pacman -S sudo
```

### Make Root Password

```bash
passwd
```

### Add User

```bash
mkdir /etc/sudoers.d
touch /etc/sudoers.d/wheel
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel # setup sudoers file
useradd -m -G wheel -s /bin/bash {username} # add user
passwd {username} # set default user password
```

### Change User

```bash
su {username} # change user, not root
```

### Set Timezone

```bash
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
```

### Install base-devel

```bash
pacman -S base-devel
```

### Export Environments

```bash
# devenv path
export DEVENV="$HOME/projects/devenv"

# XDG Base Directory
# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
```

### Install Git - [https://git-scm.com](https://git-scm.com/)

```bash
pacman -S git
```

### Clone DevEnv

```bash
git clone https://github.com/bynaki/devenv.git $DEVENV
```

### Configure Git

```bash
ln -s $DEVENV/gitconfig ~/.gitconfig
```

### Install yay - https://github.com/Jguer/yay

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Install ripgrep - https://github.com/BurntSushi/ripgrep

> It’s necessary for Neovim.
> 

```bash
sudo pacman -S ripgrep
```

## Fish

### Install fish - **[https://fishshell.com](https://fishshell.com/)**

```bash
sudo pacman -S fish
```

### Default fish shell

[Default Shell](https://www.notion.so/Default-Shell-6a4cbd1ad17e4f2f8f9e04f62bdbd108)

1. Add the shell to /etc/shells with:
    
    ```bash
    fish
    echo (which fish) | sudo tee -a /etc/shells
    ```
    
2. Change default shell with:
    
    ```bash
    chsh -s (which fish)
    ```
    

### Install Fisher - https://github.com/jorgebucaran/fisher

> Plugin manager for fish.
> 

```bash
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```

### Install nvm.fish (for node) - https://github.com/jorgebucaran/nvm.fish

> node.js manager. It’s necessary for Neovim.
> 

```bash
fisher install jorgebucaran/nvm.fish
nvm install latest
node --version > $HOME/.nvmrc # An .nvmrc file makes it easy to lock a specific version
```

### Install yarn - [https://yarnpkg.com](https://yarnpkg.com/)

> Node.js >= 16.10
> 

```bash
corepack enable
corepack prepare yarn@stable --activate
```

### Install Tide - https://github.com/IlanCosman/tide

> Shell theme, use version 5
> 

```bash
fisher install IlanCosman/tide@v5
```

### Install z - https://github.com/jethrokuan/z

> z tracks the directories you visit.
> 

```bash
fisher install jethrokuan/z
```

### Install exa - **[https://the.exa.website](https://the.exa.website/)**

> A  modern replacement for ls.
> 

```bash
sudo pacman -S exa
```

### Install ghq - https://github.com/x-motemen/ghq

> Manage remote repository clones.
> 
1. Typing:

```bash
yay -S ghq
```

1. Add in .gitconfig

```bash
[ghq]
  root = ~/ghq
```

### Install peco - https://github.com/peco/peco

> Simplistic interactive filtering tool.
> 

```bash
sudo pacman -Syu peco
```

### Configure Fish

```bash
ln -s $DEVENV/config/fish/config.fish $XDG_CONFIG_HOME/fish/config.fish
```

## Tmux

### Install tmux - [https://github.com/tmux/tmux/wiki](https://github.com/tmux/tmux/wiki)

```bash
sudo pacman -S tmux
```

### Install tpm (tmux plugin manager) - https://github.com/tmux-plugins/tpm

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Configure Tmux

```bash
ln -s %DEVENV/.tmux.conf $HOME/.tmux.conf
```

### Install Tmux Plugins

Press `prefix key` + `I`

### Notice

- client에서 tmux 세션을 실행하려면 `tmux -2` 옵션을 사용해야 nvim에서 제대로 배경색이 표시된다.

# Neovim

### Install Neovim

```bash
sudo pacman -S neovim
```

### Configure Neovim

```bash
ln -s $DEVENV/config/nvim $XDG_CONFIG_HOME/nvim
```

### Install Packer - https://github.com/wbthomason/packer.nvim

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

### Install Plugins In Neovim

```bash
:PackerInstall
```
