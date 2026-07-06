# Set XDG config home before tools that derive paths from it.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

export STARSHIP_CONFIG=~/.config/starship.toml

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
