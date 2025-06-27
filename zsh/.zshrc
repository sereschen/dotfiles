export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.oh-my-zsh
ENABLE_CORRECTION="true"


eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship.toml


plugins=(
	git
  bundler
  dotenv
  macos
  rake
  rbenv
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  zsh-autocomplete
  ruby
  zsh-vi-mode
)


source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi



# if [[ -o interactive ]]; then
#     fastfetch
# fi


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

eval "$(fzf --zsh)"
. "$HOME/.local/bin/env"
eval "$(zellij setup --generate-auto-start zsh)"
