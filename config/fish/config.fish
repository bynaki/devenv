if status --is-login
  set fish_greeting ""

  set -gx TERM xterm-256color
  set -gx EDITOR nvim

# XDG base directory
  set -gx XDG_DATA_HOME $HOME/.local/share
  set -gx XDG_CONFIG_HOME $HOME/.config
  set -gx XDG_STATE_HOME $HOME/.local/state

# devenv project path
  set -gx DEVENV $HOME/devenv

# user fish functions path
  set -g fish_function_path $fish_function_path $DEVENV/config/fish/functions

# settings for each os
  switch (uname)
    case Darwin
      source $DEVENV/config/fish/config-macos.fish
    case Linux
      source $DEVENV/config/fish/config-linux.fish
    case '*'
      source $DEVENV/config/fish/config-windows.fish
  end

  command -qv nvim && alias vim nvim
  alias tmux "tmux -2"

# call fish key binding function
  fish_user_key_bindings

  cd ~
# use node.js
  if test -f $XDG_CONFIG_HOME/fish/completions/nvm.fish
    nvm use # must be `.nvmrc`
  end
  clear
# run neofetch
  command -qv neofetch && neofetch
end
