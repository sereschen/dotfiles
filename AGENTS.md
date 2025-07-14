## AGENTS.md

This repository contains personal dotfiles for various tools. Each tool's configuration is in its own directory.

### General Guidelines

*   **Code Style**: Maintain the existing code style. There is no repo-wide linter.
*   **Testing**: Some subdirectories may have their own tests. For example, to run tests for `zsh-syntax-highlighting`:
    ```bash
    cd oh-my-zsh/.oh-my-zsh/plugins/zsh-syntax-highlighting && make test
    ```
*   **Error Handling**: Ensure scripts and configurations are robust and handle potential errors gracefully.
*   **Dependencies**: Each tool has its own dependencies, as listed in the root `README.md`.

### Structure

*   `aerospace/`: Configuration for `aerospace` window manager.
*   `ghostty/`: Configuration for `ghostty` terminal.
*   `lazyvim/`: Configuration for `nvim` with LazyVim.
*   `nix-darwin/`: Nix configuration for macOS.
*   `oh-my-zsh/`: Configuration and plugins for `oh-my-zsh`.
*   `starship/`: Configuration for `starship` prompt.
*   `tmux/`: Configuration for `tmux`.
*   `zellij/`: Configuration for `zellij` terminal multiplexer.
