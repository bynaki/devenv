# Configure Tmux

Created: August 11, 2023 9:18 PM

## Tmux Home

[Home](https://github.com/tmux/tmux/wiki)

## Install tmux

**on Mac:**

```bash
brew install tmux
```

**on Arch Linux:**

```bash
sudo pacman -S tmux
```

## Install tpm

[https://github.com/tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)

> tmux plugin manager
> 

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## Configure Tmux

```bash
ln -sf %DEVENV/.tmux.conf $HOME/.tmux.conf
```

## Install Tmux Plugins

- Press `prefix key` + `I`

## Notice

- client에서 tmux 세션을 실행하려면 `tmux -2` 옵션을 사용해야 nvim에서 제대로 배경색이 표시된다.