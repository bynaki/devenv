# Essential Development Environment on Arch Linux in Docker (Mac Silicon)

Created: February 23, 2023 9:46 PM

## Docker Run

[Docker Docs: How to build, share, and run applications](https://docs.docker.com/)

> Mac Silicon 이지만 amd64 아키텍쳐로
> 

```bash
docker run -it --name "devenv-arch" --platform linux/amd64 archlinux
```

## **Initialize keyring & Update**

[How to Setup | Arch WSL official documentation](https://www.notion.so/How-to-Setup-Arch-WSL-official-documentation-a0e2b2f9edd74ca9bb619c518a745e36?pvs=21)

> Please excute these commands to initialize the keyring. (This step is necessary to use pacman.)
> 

```bash
pacman-key --init
pacman-key --populate
pacman -Sy archlinux-keyring
pacman -Su
```

## Install Sudo

```bash
pacman -S sudo
```

## Make Root Password

```bash
passwd
```

## Add User

```bash
mkdir /etc/sudoers.d
touch /etc/sudoers.d/wheel
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel # setup sudoers file
useradd -m -G wheel -s /bin/bash {username} # add user
passwd {username} # set default user password
```

## Change User

```bash
su {username} # change user, not root
```

## Set Timezone

```bash
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
```

## Install base-devel

```bash
pacman -S base-devel
```

## Set Path Environments

```bash
# devenv path
export DEVENV="$HOME/devenv"

# XDG Base Directory
# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
```

## Generate a new SSH key

[Generating a new SSH key and adding it to the ssh-agent - GitHub Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

## Add a new SSH key to your GitHub account

[Adding a new SSH key to your GitHub account - GitHub Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)

## Install Git

[Git](https://git-scm.com/)

```bash
pacman -S git
```

## Git Configure Symbolic Link

```bash
ln -sf $DEVENV/.gitconfig ~/.gitconfig
```

## Install yay

[https://github.com/Jguer/yay](https://github.com/Jguer/yay)

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## Install ripgrep

[https://github.com/BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)

> It’s necessary for Neovim.
> 

```bash
sudo pacman -S ripgrep
```