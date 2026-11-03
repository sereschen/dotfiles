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
| `tmux-navigator.lua` | Vim-tmux pane navigation, enabled only inside tmux |
| `rex-navigator.lua` | Neovim/Rex pane navigation, enabled only inside Rex |
| `nvim-lint.lua` | Async linting |
| `overseer.lua` | Task runner |
| `refactoring.lua` | Refactoring tools |
| `obsidian.lua` | Obsidian vault integration |
| `one-liners.lua` | Small single-line plugin configs |

The Obsidian integration uses `~/projects/grit/` as its `work` workspace and is
loaded only when that directory exists. Change both the workspace path and the
`cond` directory check in `lua/plugins/obsidian.lua` when choosing another vault.

## Pane navigation

`Ctrl-h/j/k/l` moves between Neovim splits first, then into the adjacent
multiplexer pane at an editor edge. `vim-tmux-navigator` handles tmux sessions;
`rex-navigator.nvim` handles Rex sessions. Outside either multiplexer, LazyVim
keeps its normal window navigation. Nested tmux/Rex sessions are unsupported.

Rex also needs the companion loaded by the [Rex package](../rex/README.md#neovim-navigation).
Install the Neovim plugin before reloading Rex. The explicit Lazy key mappings
keep LazyVim from replacing the Rex navigation mappings during startup.

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
- Rex navigation requires Neovim 0.10+, the Rex CLI, and `ps` on the Rex server.
  Navigation is available in normal and terminal modes, not insert mode.
