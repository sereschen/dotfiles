


setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
autoload bashcompinit && bashcompinit
autoload -Uz compinit
compinit

eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship.toml

export XDG_CONFIG_HOME="/Users/sergio/.config"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^w' autosuggest-execute
bindkey '^e' autosuggest-accept
bindkey '^u' autosuggest-toggle
bindkey '^L' vi-forward-word
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

alias la=tree
alias cat=bat
alias cd=z





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
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR=~/.nvm

alias reload-nix='sudo nix run nix-darwin -- switch --flake ~/.config/nix'
alias edit-nix='nvim ~/dotfiles/nix-darwin/.config/nix/flake.nix'

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/postgresql@14/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/postgresql@14/lib"
export CPPFLAGS="-I/usr/local/opt/postgresql@14/include"
export PKG_CONFIG_PATH="/usr/local/opt/postgresql@14/lib/pkgconfig"
# bun completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# Example for Zsh (.zshrc) - Ensure ONE of these eval lines is present
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PATH=$PATH:$(go env GOPATH)/bin

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

alias ls="eza  --icons=always --all -1 --git"
. "$HOME/.local/bin/env"
export MTL_LANGUAGE_REVISION=Metal24

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/sergio/.lmstudio/bin"
# End of LM Studio CLI section

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
