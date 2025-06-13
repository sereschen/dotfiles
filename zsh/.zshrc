ZSH_THEME="robbyrussell"

ENABLE_CORRECTION="true"

plugins=(
	git
)

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if [[ -o interactive ]]; then
    fastfetch
fi


export NVM_DIR=~/.nvm

alias nixd='sudo nix run nix-darwin -- switch --flake ~/.config/nix'

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

eval "$(starship init zsh)"
eval "$(fzf --zsh)"
. "$HOME/.local/bin/env"
