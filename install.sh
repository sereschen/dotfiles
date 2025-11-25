#!/usr/bin/env bash

set -eo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Detect OS
detect_os() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		OS="macos"
	elif [[ -f /etc/os-release ]]; then
		ID="" ID_LIKE="" || true
		# shellcheck disable=SC1091
		. /etc/os-release
		if [[ "${ID:-}" == "arch" ]] || [[ "${ID_LIKE:-}" == *"arch"* ]]; then
			OS="arch"
		elif [[ "${ID:-}" == "ubuntu" ]] || [[ "${ID:-}" == "debian" ]]; then
			OS="debian"
		else
			OS="unknown"
		fi
	else
		OS="unknown"
	fi
}

# Initialize selected packages array
SELECTED_PACKAGES=()

# Print header
print_header() {
	clear
	echo -e "${BLUE}"
	echo "╔════════════════════════════════════════╗"
	echo "║     Dotfiles Installation Script       ║"
	echo "║                                        ║"
	echo "║  Detected OS: ${YELLOW}$(echo $OS | tr '[:lower:]' '[:upper:]')$(printf '%*s' $((31 - ${#OS})) '')${BLUE}║"
	echo "╚════════════════════════════════════════╝"
	echo -e "${NC}"
}

# Print section header
print_section() {
	echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
	echo -e "${YELLOW}$1${NC}"
	echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Package descriptions
get_package_description() {
	case $1 in
	git) echo "git" ;;
	zsh) echo "zsh" ;;
	nvim) echo "neovim 0.9+" ;;
	tmux) echo "tmux" ;;
	starship) echo "starship" ;;
	fd) echo "fd (find alternative)" ;;
	bat) echo "bat (cat with syntax highlighting)" ;;
	fzf) echo "fzf (fuzzy finder)" ;;
	eza) echo "eza (ls alternative)" ;;
	tree) echo "tree (directory viewer)" ;;
	ripgrep) echo "ripgrep (fast grep alternative)" ;;
	pyenv) echo "pyenv (Python version manager)" ;;
	nvm) echo "nvm (Node version manager)" ;;
	go) echo "go (Go programming language)" ;;
	bun) echo "bun (JavaScript runtime)" ;;
	uv) echo "uv (Python package installer)" ;;
	postgresql) echo "postgresql (database)" ;;
	docker) echo "docker (containerization)" ;;
	gh) echo "gh (GitHub CLI)" ;;
	*) echo "$1" ;;
	esac
}

# Get package name for current OS
get_package_name() {
	local package=$1
	case $OS in
	macos)
		case $package in
		git) echo "git" ;;
		zsh) echo "zsh" ;;
		nvim) echo "neovim" ;;
		tmux) echo "tmux" ;;
		starship) echo "starship" ;;
		fd) echo "fd" ;;
		bat) echo "bat" ;;
		fzf) echo "fzf" ;;
		eza) echo "eza" ;;
		tree) echo "tree" ;;
		ripgrep) echo "ripgrep" ;;
		pyenv) echo "pyenv" ;;
		nvm) echo "nvm" ;;
		go) echo "go" ;;
		bun) echo "bun" ;;
		uv) echo "uv" ;;
		postgresql) echo "postgresql" ;;
		docker) echo "docker" ;;
		gh) echo "gh" ;;
		esac
		;;
	arch)
		case $package in
		git) echo "git" ;;
		zsh) echo "zsh" ;;
		nvim) echo "neovim" ;;
		tmux) echo "tmux" ;;
		starship) echo "starship" ;;
		fd) echo "fd" ;;
		bat) echo "bat" ;;
		fzf) echo "fzf" ;;
		eza) echo "eza" ;;
		tree) echo "tree" ;;
		ripgrep) echo "ripgrep" ;;
		pyenv) echo "pyenv" ;;
		nvm) echo "nvm" ;;
		go) echo "go" ;;
		bun) echo "bun" ;;
		uv) echo "uv" ;;
		postgresql) echo "postgresql" ;;
		docker) echo "docker" ;;
		gh) echo "github-cli" ;;
		esac
		;;
	debian)
		case $package in
		git) echo "git" ;;
		zsh) echo "zsh" ;;
		nvim) echo "neovim" ;;
		tmux) echo "tmux" ;;
		starship) echo "starship" ;;
		fd) echo "fd-find" ;;
		bat) echo "bat" ;;
		fzf) echo "fzf" ;;
		eza) echo "exa" ;;
		tree) echo "tree" ;;
		ripgrep) echo "ripgrep" ;;
		pyenv) echo "pyenv" ;;
		nvm) echo "npm" ;;
		go) echo "golang-go" ;;
		bun) echo "bun" ;;
		uv) echo "uv" ;;
		postgresql) echo "postgresql" ;;
		docker) echo "docker.io" ;;
		gh) echo "gh" ;;
		esac
		;;
	esac
}

# Check if package is selected
is_selected() {
	local package=$1
	for selected in "${SELECTED_PACKAGES[@]}"; do
		if [[ "$selected" == "$package" ]]; then
			return 0
		fi
	done
	return 1
}

# Toggle package selection
toggle_package() {
	local package=$1
	if is_selected "$package"; then
		SELECTED_PACKAGES=("${SELECTED_PACKAGES[@]/$package/}")
	else
		SELECTED_PACKAGES+=("$package")
	fi
}

# Interactive selector
interactive_selector() {
	while true; do
		print_header
		print_section "Package Selection"

		echo -e "\n${GREEN}✓ Selected packages: ${#SELECTED_PACKAGES[@]}${NC}\n"

		if [[ ${#SELECTED_PACKAGES[@]} -gt 0 ]]; then
			echo -e "${GREEN}Selected:${NC}"
			for pkg in "${SELECTED_PACKAGES[@]}"; do
				echo "  • $(get_package_description "$pkg")"
			done
			echo
		fi

		echo -e "${YELLOW}Select a category:${NC}"
		echo "  [1] Required Tools"
		echo "  [2] Development Tools"
		echo "  [3] Language Managers"
		echo "  [4] Other Tools"
		echo "  [5] Install Selected"
		echo "  [6] Cancel"
		echo
		read -rp "Enter choice [1-6]: " choice

		case "$choice" in
		1) select_category "required" ;;
		2) select_category "dev" ;;
		3) select_category "lang" ;;
		4) select_category "other" ;;
		5)
			if [[ ${#SELECTED_PACKAGES[@]} -eq 0 ]]; then
				echo -e "\n${RED}✗ No packages selected. Please select at least one package.${NC}\n"
				sleep 2
			else
				return 0
			fi
			;;
		6)
			echo -e "\n${YELLOW}Installation cancelled.${NC}\n"
			exit 0
			;;
		*)
			echo -e "${RED}Invalid option. Please try again.${NC}"
			sleep 1
			;;
		esac
	done
}

# Select from category
select_category() {
	local category=$1
	local -a items=()
	local title=""

	case $category in
	required)
		items=(git zsh nvim tmux starship)
		title="Required Tools"
		;;
	dev)
		items=(fd bat fzf eza tree ripgrep)
		title="Development Tools"
		;;
	lang)
		items=(pyenv nvm go bun uv)
		title="Language Managers"
		;;
	other)
		items=(postgresql docker gh)
		title="Other Tools"
		;;
	esac

	while true; do
		clear
		print_header
		print_section "Select from: $title"

		echo -e "\n${YELLOW}Enter number to toggle, or press Enter to return to main menu:\n${NC}"

		local i=1
		for item in "${items[@]}"; do
			if is_selected "$item"; then
				echo -e "${GREEN}✓${NC} [$i] $(get_package_description "$item")"
			else
				echo -e "  [$i] $(get_package_description "$item")"
			fi
			i=$((i + 1))
		done

		echo
		read -rp "Enter selection: " choice

		if [[ -z "$choice" ]]; then
			break
		elif [[ "$choice" =~ ^[0-9]+$ ]] && [[ $choice -ge 1 ]] && [[ $choice -le ${#items[@]} ]]; then
			toggle_package "${items[$((choice - 1))]}"
		else
			echo -e "${RED}Invalid selection.${NC}"
			sleep 1
		fi
	done
}

# Install packages
install_packages() {
	print_header
	print_section "Installing Packages"

	local failed_packages=()

	for package in "${SELECTED_PACKAGES[@]}"; do
		install_package "$package" || failed_packages+=("$package")
	done

	echo
	print_section "Installation Summary"

	if [[ ${#failed_packages[@]} -eq 0 ]]; then
		echo -e "${GREEN}✓ All packages installed successfully!${NC}\n"
	else
		echo -e "${YELLOW}⚠ Some packages failed to install:${NC}"
		for pkg in "${failed_packages[@]}"; do
			echo "  • $(get_package_description "$pkg")"
		done
		echo
	fi
}

# Install single package
install_package() {
	local package=$1
	local pkg_name
	pkg_name=$(get_package_name "$package")

	case $OS in
	macos) install_macos "$package" "$pkg_name" ;;
	arch) install_arch "$package" "$pkg_name" ;;
	debian) install_debian "$package" "$pkg_name" ;;
	*)
		echo -e "${RED}✗ Unknown OS: $OS${NC}"
		return 1
		;;
	esac
}

# macOS installation using Homebrew
install_macos() {
	local package=$1
	local pkg_name=$2

	# Check if Homebrew is installed
	if ! command -v brew &>/dev/null; then
		echo -e "${YELLOW}⚠ Homebrew not found. Installing Homebrew...${NC}"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	echo -n "Installing ${BLUE}$package${NC}... "

	if brew list "$pkg_name" &>/dev/null; then
		echo -e "${GREEN}✓ Already installed${NC}"
		return 0
	fi

	if brew install "$pkg_name" &>/dev/null; then
		echo -e "${GREEN}✓ Installed${NC}"
		return 0
	else
		echo -e "${RED}✗ Failed${NC}"
		return 1
	fi
}

# Arch installation
install_arch() {
	local package=$1
	local pkg_name=$2

	echo -n "Installing ${BLUE}$package${NC}... "

	if pacman -Q "$pkg_name" &>/dev/null; then
		echo -e "${GREEN}✓ Already installed${NC}"
		return 0
	fi

	if sudo pacman -S --noconfirm "$pkg_name" &>/dev/null; then
		echo -e "${GREEN}✓ Installed${NC}"
		return 0
	else
		echo -e "${RED}✗ Failed${NC}"
		return 1
	fi
}

# Debian/Ubuntu installation
install_debian() {
	local package=$1
	local pkg_name=$2

	echo -n "Installing ${BLUE}$package${NC}... "

	if dpkg -l | grep -q "^ii  $pkg_name"; then
		echo -e "${GREEN}✓ Already installed${NC}"
		return 0
	fi

	if sudo apt-get update &>/dev/null && sudo apt-get install -y "$pkg_name" &>/dev/null; then
		echo -e "${GREEN}✓ Installed${NC}"
		return 0
	else
		echo -e "${RED}✗ Failed${NC}"
		return 1
	fi
}

# Main flow
main() {
	detect_os

	if [[ "$OS" == "unknown" ]]; then
		echo -e "${RED}✗ Unknown or unsupported OS. Currently supported: macOS, Arch Linux, Ubuntu/Debian${NC}"
		exit 1
	fi

	interactive_selector
	install_packages

	printf "%b\n" "${GREEN}Installation complete!${NC}"
	printf "%b\n" "${YELLOW}Next steps:${NC}"
	echo "  1. Create symlinks for configuration files"
	printf "%b\n" "  2. Set zsh as default shell: ${BLUE}chsh -s /bin/zsh${NC}"
	printf "%b\n" "  3. Source your shell config: ${BLUE}source ~/.zshrc${NC}"
}

# Run main function
main
