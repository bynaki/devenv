# Fish Shell

Created: August 10, 2023 7:18 PM

## Install Fish Shell

[fish shell](https://fishshell.com/)

### on macOS:

```bash
brew install fish
```

### on Arch Linux:

```bash
sudo pacman -S fish
```

## Default Fish Shell

[Default Shell](https://www.notion.so/Default-Shell-6a4cbd1ad17e4f2f8f9e04f62bdbd108?pvs=21)

1. Add the shell to /etc/shells with:

```bash
fish
echo (which fish) | sudo tee -a /etc/shells
```

1. Change default shell with:

```bash
chsh -s (which fish)
```

## Install Fisher

[https://github.com/jorgebucaran/fisher](https://github.com/jorgebucaran/fisher)

> Plugin manager for fish.
> 

```bash
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

## Install Tide

[https://github.com/IlanCosman/tide](https://github.com/IlanCosman/tide)

> Shell theme, use version 5
> 

```bash
fisher install IlanCosman/tide@v5
```

## Install z

[https://github.com/jethrokuan/z](https://github.com/jethrokuan/z)

> z tracks the directories you visit.
> 

```bash
fisher install jethrokuan/z
```

## Install exa

[exa · a modern replacement for ls](https://the.exa.website/)

> A  modern replacement for ls.
> 

### on Mac:

```bash
brew install exa
```

### on Arch Linx:

```bash
sudo pacman -S exa
```

## Install peco

[https://github.com/peco/peco](https://github.com/peco/peco)

> Simplistic interactive filtering tool.
> 

### on Mac:

```bash
brew install peco
```

### on Arch Linux:

```bash
sudo pacman -S peco
```

## Configure Fish

```bash
fish ~/devenv/config/fish/config.fish
ln -sf $DEVENV/config/fish/config.fish $XDG_CONFIG_HOME/fish/config.fish
```