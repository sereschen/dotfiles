# LazyVim Module

Neovim configuration based on LazyVim. Plugins are managed by lazy.nvim which self-bootstraps on first launch.

## Stow

```bash
stow -d ~/dotfiles -t ~ lazyvim
```

This symlinks `.config/nvim/` → `~/.config/nvim/`.

## Config files

| Path | Purpose |
|------|---------|
| `lua/config/lazy.lua` | lazy.nvim bootstrap + plugin spec loader |
| `lua/config/autocmds.lua` | Custom autocommands |
| `lua/config/keymaps.lua` | Custom keymaps |
| `lua/config/options.lua` | Neovim options |
| `lua/plugins/*.lua` | Plugin specs (one per plugin/group) |

## Plugin specs

| File | What it adds |
|------|-------------|
| `colorscheme.lua` | Catppuccin theme |
| `snacks.lua` | Snacks.nvim utilities |
| `neotest.lua` | Test runner framework |
| `dap.lua` | Debug adapter protocol |
| `aerial.lua` | Code outline/symbols |
| `noice.lua` | UI for messages/cmdline |
| `multicursor.lua` | Multi-cursor editing |
| `tmux-navigator.lua` | Vim-tmux pane navigation |
| `nvim-lint.lua` | Async linting |
| `overseer.lua` | Task runner |
| `refactoring.lua` | Refactoring tools |
| `obsidian.lua` | Obsidian vault integration |
| `one-liners.lua` | Small single-line plugin configs |

## Dependencies

### Required (brew)
- `neovim` (0.9+)
- `ripgrep` — used by telescope/grep
- `fd` — used by telescope/file finder

### Self-bootstrapping (no manual install)
- **lazy.nvim** — cloned automatically on first `nvim` launch via `lua/config/lazy.lua`
- All plugins — installed automatically by lazy.nvim on first launch

### Optional
- Language servers, formatters, and linters are installed via Mason (built into LazyVim)
