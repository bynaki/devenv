# Install Node.js

Created: August 15, 2023 10:09 PM

## Node.js Home

[Node.js](https://nodejs.org)

## With nvm.fish

[https://github.com/jorgebucaran/nvm.fish](https://github.com/jorgebucaran/nvm.fish)

> node.js manager in fish shell. It’s necessary for Neovim.
> 

### Install nvm.fish:

```bash
fisher install jorgebucaran/nvm.fish
nvm install latest
node --version > $HOME/.nvmrc # An .nvmrc file makes it easy to lock a specific version
```

## **Install yarn**

[Home](https://yarnpkg.com/)

> Node.js >= 16.10
> 

```bash
corepack enable
corepack prepare yarn@stable --activate
```