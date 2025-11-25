# Dotfiles for Linux/macOS

A comprehensive dotfiles repository with configurations for shell, terminal multiplexing,
editor, and various development tools. Optimized for macOS with Linux compatibility.

## Required Packages

Essential tools required for full functionality:

- `git` - Version control
- `zsh` - Shell (with oh-my-zsh optional)
- `nvim` - Neovim 0.9+ (text editor)
- `tmux` - Terminal multiplexer
- `starship` - Cross-shell prompt

## Optional Tools

These tools enhance functionality but are not required. The dotfiles intelligently
detect and use them if available:

- `fd` - Fast alternative to `find`
- `bat` - Cat clone with syntax highlighting
- `fzf` - Fuzzy finder
- `zoxide` - Smart directory navigation (z alternative)
- `eza` - Modern ls replacement
- `pyenv` - Python version manager
- `go` - Go programming language
- `tree` - Directory tree viewer
- `uv` - Python package installer
- `bun` - JavaScript runtime

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Create symlinks for each tool's configuration:
   ```bash
   # Example for zsh
   ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
   
   # Example for tmux
   ln -s ~/.dotfiles/tmux/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
   
   # Example for nvim
   ln -s ~/.dotfiles/nvim/.config/nvim ~/.config/nvim
   ```

3. Install package manager (if not present):
   - **macOS**: `brew install zsh tmux starship nvim fd bat fzf eza`
   - **Ubuntu/Debian**: `sudo apt install zsh tmux starship neovim fd-find bat fzf exa`

4. Set zsh as default shell (if needed):
   ```bash
   chsh -s /bin/zsh
   ```

## Directory Structure

```
dotfiles/
├── zsh/              # Zsh shell configuration
├── tmux/             # Tmux terminal multiplexer
├── nvim/             # Neovim editor config
├── starship/         # Starship prompt config
├── nix-darwin/       # nix-darwin configuration (macOS)
└── [other tools]/    # Additional tool configurations
```

## Features

- **Smart conditional loading**: Tools are only initialized if available
- **Cross-platform support**: Detects OS and applies platform-specific configurations
- **Catppuccin theme**: Consistent color scheme across tools
- **VI keybindings**: Consistent VI mode across shell and tmux
- **Session persistence**: Tmux sessions are automatically restored on startup
- **Development-ready**: Quick environment switching for various languages

## Customization

Environment-specific overrides can be placed in `~/.local/bin/env` which is sourced
at the end of `.zshrc`. This allows local customizations without modifying versioned files.

## Troubleshooting

- **Slow shell startup**: Run `time zsh -i -c exit` to profile startup time
- **Tmux colors not working**: Ensure `default-terminal` is set to `screen-256color`
- **FZF not working**: Verify `fd` is installed for optimal `FZF_DEFAULT_COMMAND`

## License

MIT
