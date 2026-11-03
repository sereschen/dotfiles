# Rex Module

Rex configuration with tmux-like `Ctrl-a` sequences. This package is independent
of the Ghostty and tmux packages and does not modify their configurations.

## Stow

From the root of this repository, run:

```bash
stow --simulate --verbose --target="$HOME" rex
stow --verbose --target="$HOME" rex
```

This links `.config/rex/init.lua` into `~/.config/rex/init.lua`. Only the hidden
configuration tree is installed; this README stays in the repository.

Rex must already be installed. This package is stowed separately; `setup.sh`
continues to stow only `zsh`, `tmux`, and `lazyvim`.

## Bindings

Press `Ctrl-a`, then the listed key, except for `Cmd-k`.

| Key | Behavior |
|-----|----------|
| `Cmd-k` | Native Clear Terminal; replaces Rex's default session picker |
| `o` | Rex session picker; replaces the role of the tmux `tv sesh` popup, not its implementation |
| `Ctrl-a` | Send `Ctrl-a` through to the terminal |
| `h` / `l` | Previous / next tab |
| `1`–`9` | Select tab by index |
| `r` | Reload the Rex configuration |
| `w` | New tab |
| `z` | Toggle pane zoom |
| `-` | Split down |
| `Shift-\` (`\|`) | Split right |
| `j` / `k` | Focus the pane below / above |
| `c` | Close the current pane |
| `,` / `.` | Resize left / right with amount 20 |
| `=` | Resize up with amount 7 |
| `Ctrl-r` | Enter the exclusive repeat mode |

In repeat mode, `,`, `.`, and `=` resize without the prefix. Press Enter or
Escape to leave. This is not tmux's timed repeat behavior; other keys are
suppressed while this mode is active.

## Migration limits

- The earlier tmux `Ctrl-a` binding for forwarding a mouse event is superseded
  by its later `send-prefix` binding. Only prefix pass-through is migrated.
- Locking, detaching, client listing, window swapping, the command prompt,
  copy-mode selection, and sending the `clear` command are not migrated.
- The home-directory-specific new-window binding is not migrated. The ordinary
  new-tab binding does not explicitly set a working directory.
- The Sesh, Ports, and Worktrees television popups are not migrated. The `o`
  binding intentionally opens Rex's own session picker instead of television.
- TPM, tmux-sensible, tmux-yank, tmux-resurrect, tmux-continuum, tmux-open,
  tmux-fzf-links, vim-tmux-navigator, and catppuccin-tmux are not migrated.
  Ordinary pane focus does not provide Vim-aware navigation.
- tmux terminal capabilities, environment, history, mouse, clipboard, status,
  border, theme, and plugin settings are not copied into Rex.
- Ghostty's Catppuccin Mocha theme and Hack Nerd Font are not configured in Lua.
  Set the font in Rex Settings; Settings > Theme offers theme import. Ghostty's
  padding, decorations, Option-as-Alt, and SSH terminfo settings are not migrated.

## Verification

With the intended Rex CLI on `PATH`, run:

```bash
REX_CONFIG="$HOME/.config/rex/init.lua" rex config check
rex config reload
rex keymap --json
```

Use the CLI and server belonging to the intended Rex installation if multiple
versions are installed. The keymap's diagnostics must be empty. The package was
checked and reloaded on macOS with Rex server version 1758; Linux and interactive
shortcut behavior were not verified.
