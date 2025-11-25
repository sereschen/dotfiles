


setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship.toml

# Set XDG config home (works on all systems)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# macOS-specific setup with Homebrew
if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
  source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  # zsh-autosuggestions keybinds
  bindkey '^w' autosuggest-execute
  bindkey '^e' autosuggest-accept
  bindkey '^u' autosuggest-toggle
fi

# Common keybinds
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# Conditional aliases for optional tools
command -v tree &> /dev/null && alias la=tree
command -v bat &> /dev/null && alias cat=bat
command -v z &> /dev/null && alias cd=z


if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# VI Mode!!!
bindkey jj vi-cmd-mode

# if [[ -o interactive ]]; then
#     fastfetch
# fi

### FZF ###
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR=~/.nvm

# macOS-specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias reload-nix='sudo nix run nix-darwin -- switch --flake ~/.config/nix'
  alias edit-nix='nvim $HOME/dotfiles/nix-darwin/.config/nix/flake.nix'
fi

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# macOS-specific paths for OpenSSL and PostgreSQL
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/usr/local/opt/openssl/bin:$PATH"
  export PATH="/usr/local/opt/postgresql@14/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/postgresql@14/lib"
  export CPPFLAGS="-I/usr/local/opt/postgresql@14/include"
  export PKG_CONFIG_PATH="/usr/local/opt/postgresql@14/lib/pkgconfig"
fi
# Bun - optional
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
fi
# Pyenv - optional
if command -v pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# Go - optional
if command -v go &> /dev/null; then
  export PATH=$PATH:$(go env GOPATH)/bin
fi

# Zoxide - optional
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# FZF - optional
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi

# Eza - optional
if command -v eza &> /dev/null; then
  alias ls="eza  --icons=always --all -1 --git"
fi

# Local bin env - optional
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# macOS-specific Metal and LM Studio configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
  export MTL_LANGUAGE_REVISION=Metal24

  # Added by LM Studio CLI (lms)
  export PATH="$PATH:/Users/sergio/.lmstudio/bin"
  # End of LM Studio CLI section
fi

# UV - optional
if command -v uv &> /dev/null; then
  eval "$(uv generate-shell-completion zsh)"
  eval "$(uvx --generate-shell-completion zsh)"
fi
