eval "$(starship init zsh)"

# macOS-specific setup with Homebrew.
if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  # zsh-autosuggestions keybinds
  bindkey '^w' autosuggest-execute
  bindkey '^e' autosuggest-accept
  bindkey '^u' autosuggest-toggle
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun - optional
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Pyenv - optional
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# Zoxide - optional
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# FZF - optional
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi

# UV - optional
if command -v uv &> /dev/null; then
  eval "$(uv generate-shell-completion zsh)"
  eval "$(uvx --generate-shell-completion zsh)"
fi


if command -v sesh &> /dev/null; then
  if [ ! -d $HOME/.zsh/completions ]; then
    mkdir -p $HOME/.zsh/completions
    sesh completion zsh > $HOME/.zsh/completions/_sesh
  fi

  fpath=( $HOME/.zsh/completions $fpath )
  autoload -U compinit && compinit
fi
