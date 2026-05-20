# Conditional aliases for optional tools.
command -v tree &> /dev/null && alias la=tree
command -v bat &> /dev/null && alias cat=bat

# macOS-specific aliases.
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias reload-nix='sudo nix run nix-darwin -- switch --flake ~/.config/nix'
  alias edit-nix='nvim $HOME/dotfiles/nix-darwin/.config/nix/flake.nix'
fi

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# Eza - optional
if command -v eza &> /dev/null; then
  alias ls="eza --icons=always --all -1 --git"
fi
