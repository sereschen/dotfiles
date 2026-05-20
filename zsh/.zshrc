# Load modular zsh configuration from ~/.zshrc.d in lexical order.
ZSH_CUSTOM_DIR="$HOME/.zshrc.d"

if [ -d "$ZSH_CUSTOM_DIR" ]; then
  for file in "$ZSH_CUSTOM_DIR"/*.zsh(N); do
    [ -f "$file" ] && source "$file"
  done
fi
