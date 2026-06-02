#!/usr/bin/env zsh
set -euo pipefail

DOTFILES_DIR="${0:a:h}"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { printf "${GREEN}[+]${NC} %s\n" "$1" }
warn()  { printf "${YELLOW}[!]${NC} %s\n" "$1" }
error() { printf "${RED}[x]${NC} %s\n" "$1" }

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  info "Homebrew already installed"
fi

# --- Brew packages ---
info "Installing brew packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# --- TPM (Tmux Plugin Manager) ---
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  info "Cloning TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  info "TPM already installed"
fi

# --- Stow modules ---
info "Stowing zsh, tmux, lazyvim..."
for module in zsh tmux lazyvim; do
  stow -d "$DOTFILES_DIR" -t "$HOME" --restow "$module" && info "  $module stowed" || warn "  $module: stow conflict (check existing files)"
done

# --- Post-install ---
echo ""
info "Done! Next steps:"
echo "  1. Set zsh as default shell:  chsh -s \$(which zsh)"
echo "  2. Reload shell:              source ~/.zshrc"
echo "  3. Open tmux and press prefix+I to install tmux plugins"
echo "  4. Launch nvim — lazy.nvim will auto-install plugins on first run"
