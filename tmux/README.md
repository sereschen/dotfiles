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

## Popup bindings

Press the prefix (`Ctrl-a`), then the listed key. All popups use tmux's built-in
`display-popup` at 80% width and 70% height; Floax is no longer used.

| Key | Command | Purpose |
|-----|---------|---------|
| `o` | `tv sesh` | Browse and connect to sessions |
| `p` | `tv ports` | Inspect listening TCP ports and kill selected processes |
| `t` | `tv worktree` | Manage worktrees from the current pane's directory |

The Sesh and Ports popups start in `$HOME`; Worktrees starts in the current pane's
working directory. Channel definitions live in
`television/.config/television/cable/` (the `worktree` channel is defined in
`lazyworktree.toml`). In the Sesh picker, `Ctrl-r` renames the selected tmux
session with its current name prefilled; `Ctrl-d` kills the selected session.
The rename prompt uses Zsh's line editor rather than Bash-specific `read` options.

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

## Dependencies

### Required (brew)
- `tmux` 3.8+
- `fzf` and `python@3` (Python 3.10+) — required by `tmux-fzf-links`

The link picker resolves `python3` from the tmux server's `PATH`. Install Python
3.10+ and ensure it comes before macOS's system Python. On Linux, use the system
package manager or another Python installation. If needed, set `@fzf-links-python`
to an interpreter path in a local configuration; do not hardcode a Homebrew prefix
for every machine.

### Required (git clone)
- **TPM** — must be cloned manually:
  ```bash
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
  ```
  Then press `prefix + I` inside tmux to install plugins.

### Popup dependencies
- `television` — runs all three popup pickers
- `sesh` and `fd` — required by the session channel
- `lazyworktree` — required by the worktree channel; `gh` is used for its PR actions
- `lsof` and `ps` — required by the ports channel (provided by macOS)

Stow the `television`, `sesh`, and `lazyworktree` packages separately to install
their configurations; `setup.sh` currently stows only `zsh`, `tmux`, and `lazyvim`.
The tmux server preserves its inherited `PATH` and prepends
`$HOME/.config/lazyworktree/bin` and `$HOME/.local/bin`, so popup commands can use
the lazyworktree wrapper without requiring an interactive shell to load `.zshrc`.
