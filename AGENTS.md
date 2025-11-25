# Dotfiles Project Configuration

This is a cross-platform dotfiles repository containing shell, terminal, and development tool configurations. The project primarily uses shell scripts (Bash, Zsh), with Lua configuration for Neovim.

## Project Structure

```
dotfiles/
├── zsh/                    # Zsh shell configuration
├── tmux/                   # Tmux terminal multiplexer config
├── nvim/ (lazyvim)        # Neovim editor configuration with LazyVim
├── starship/              # Starship prompt configuration
├── ghostty/               # Ghostty terminal config
├── aerospace/             # Aerospace window manager config
├── nix-darwin/            # Nix-darwin macOS configuration
├── warp/                  # Warp terminal themes
├── oh-my-zsh/             # Oh-my-zsh themes (vendored)
├── install.sh             # Interactive package installer
├── README.md              # Project documentation
└── AGENTS.md              # This file
```

## Development Tools & LSP Setup

### Neovim with Mason.nvim

The project uses **Neovim with LazyVim** and **mason.nvim** for LSP, linter, and formatter management. OpenCode should be aware of which tools are installed via Mason.

**Key LSP Servers** (managed via Mason in Neovim):
- `lua_ls` - Lua language server
- `bashls` - Bash language server
- `pylsp` - Python language server
- `gopls` - Go language server
- `rust_analyzer` - Rust language server

**Linters** (managed via Mason):
- `shellcheck` - Shell script linting
- `pylint` / `flake8` - Python linting
- `golangci-lint` - Go linting
- `clippy` - Rust linting

**Formatters** (managed via Mason):
- `shfmt` - Shell script formatting (bash, sh)
- `stylua` - Lua code formatter
- `black` - Python formatter
- `gofmt` - Go formatter
- `prettier` - JavaScript/JSON/Markdown formatter

### OpenCode Integration

OpenCode should handle the following file types:

- **Shell scripts** (.sh, .bash) - Use `shellcheck` LSP and `shfmt` formatter
- **Zsh config** (.zshrc) - Use `shellcheck` LSP
- **Lua** (.lua) - Use `lua_ls` LSP and `stylua` formatter  
- **Python** (.py) - Use appropriate Python LSP and formatter
- **Go** (.go) - Use `gopls` LSP and `gofmt` formatter
- **Rust** (.rs) - Use `rust_analyzer` LSP and `rustfmt` formatter
- **JSON** (.json) - Use `prettier` formatter
- **YAML** (.yaml, .yml) - Use appropriate YAML formatter
- **Markdown** (.md) - Use `prettier` formatter (if available in Mason)

## Code Quality Standards

### Shell Scripts

- Follow **ShellCheck** recommendations - all warnings should be addressed
- Use the pattern of conditionally checking for tool availability before using aliases
- Prefer `[[` over `[` for test conditions
- Always quote variables: `"$VAR"` not `$VAR`
- Use `set -eo pipefail` for safer scripts
- Comments should explain the "why" not the "what"

### Lua Configuration

- Follow Neovim and LazyVim best practices
- Use `stylua` for consistent formatting (config in `lazyvim/.config/nvim/stylua.toml`)
- No inline comments in plugin configurations
- Document complex configurations with comment blocks

### Bash/Zsh Configuration

- Use conditional sourcing for optional tools to avoid hard dependencies
- Variables should be exported at the top level
- Use comments to mark sections (e.g., "# macOS-specific setup")
- Keep PATH modifications clean and organized

## Formatting & Linting Rules

### Before Committing

1. **Shell scripts** - Must pass `shellcheck` without errors
2. **Lua files** - Must be formatted with `stylua`
3. **Markdown** - Should follow `.markdownlint.yaml` rules
4. **JSON/YAML** - Should be properly formatted

### Disabling Warnings

Only suppress warnings when there's a valid reason:
- Use `shellcheck disable=SCXXXX` for shell script exceptions
- Use `--luacheck-ignore` or `-- luacheck: ignore` for Lua exceptions
- Document why the exception is necessary

## Installation & Testing

The `install.sh` script provides interactive installation of required packages:

- Detects OS (macOS, Arch, Ubuntu/Debian)
- Allows selective package installation
- Uses appropriate package managers (Homebrew, pacman, apt)

When making changes to `install.sh`:
- Must pass `shellcheck` without warnings
- Test on all supported platforms if possible
- Update documentation if adding new packages

## Integration with OpenCode

When working on this project, OpenCode should:

1. **Check LSP diagnostics** - Respect `shellcheck` warnings and other LSP feedback
2. **Apply formatters** - Use `shfmt`, `stylua`, and `prettier` as configured
3. **Avoid specific patterns** - Skip warning suppression unless necessary
4. **Maintain consistency** - Follow existing code style across configurations

### Mason.nvim Availability

If tools installed in Mason are available in the system PATH:
- Use them in code analysis
- Reference their installed versions in documentation
- Suggest using Mason if a tool is missing

## Related Files

- `.markdownlint.yaml` - Markdown linting configuration
- `lazyvim/.config/nvim/stylua.toml` - Lua formatting configuration  
- `.gitignore` - Files to exclude from version control
- `README.md` - User-facing documentation
