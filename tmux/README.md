# Tmux Module

Tmux configuration with TPM plugin manager, Catppuccin theme, and vi-mode keybindings.

## Stow

```bash
stow -d ~/dotfiles -t ~ tmux
```

This symlinks `.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`.

## Config files

| File | Purpose |
|------|---------|
| `.config/tmux/tmux.conf` | Main config — keybinds, options, plugin list, theme settings |

## Key settings

- Prefix: `Ctrl-a`
- Vi copy mode
- Mouse enabled
- Status bar at top (dual-line)
- Base index 1
- Session restore on startup via continuum
- `tmux-256color` for applications inside tmux
- Ghostty truecolor and synchronized-output support

## Colors and terminal support

The configuration requires **tmux 3.8 or newer** for its built-in theme options.
The Catppuccin plugin styles the status line and panes. The separate
`dark-theme-*` palette styles tmux's built-in popups, menus, and other UI with
Catppuccin Mocha colors. `theme dark` prevents terminal light-theme detection from
selecting a mismatched palette.

Applications inside tmux use `TERM=tmux-256color`. Ghostty's outer terminal is
configured separately with `RGB` and `sync` terminal features, preserving truecolor
and synchronized drawing for applications such as Pi.

After changing the configuration, press `Ctrl-a`, then `r` to reload it. Close and
reopen existing popups to check their colors; the palette change does not require
restarting the tmux server.

## Plugins (managed by TPM)

| Plugin | Purpose |
|--------|---------|
| `tmux-plugins/tpm` | Plugin manager |
| `tmux-plugins/tmux-sensible` | Sensible defaults |
| `tmux-plugins/tmux-yank` | System clipboard yank |
| `tmux-plugins/tmux-resurrect` | Save/restore sessions |
| `tmux-plugins/tmux-continuum` | Auto-restore on start |
| `tmux-plugins/tmux-open` | Open URLs/files from copy mode |
| `alberti42/tmux-fzf-links` | Fuzzy-find links in pane |
| `christoomey/vim-tmux-navigator` | Seamless vim/tmux pane nav |
| `omerxx/catppuccin-tmux` | Catppuccin theme |
| `omerxx/tmux-floax` | Floating pane popups |

## Dependencies

### Required (brew)
- `tmux` 3.8+

### Required (git clone)
- **TPM** — must be cloned manually:
  ```bash
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
  ```
  Then press `prefix + I` inside tmux to install plugins.

### Optional (brew)
- `sesh` — used in `bind o` popup for session switching
- `television` — used in `bind o` (tv sesh) and `bind t` (tv worktree)
