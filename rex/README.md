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

Press `Ctrl-a`, then the listed key, except for `Cmd-k` and `Ctrl-h/j/k/l`.

| Key | Behavior |
|-----|----------|
| `Cmd-k` | Native Clear Terminal; replaces Rex's default session picker |
| `Ctrl-h/j/k/l` | Navigate Neovim splits first, then Rex panes; no prefix |
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

## Neovim navigation

[rex-navigator.nvim](https://github.com/baggiponte/rex-navigator.nvim) supplies
both the Neovim plugin and the Rex companion. The [LazyVim package](../lazyvim/README.md)
installs the plugin; open Neovim in Rex and wait for Lazy to finish installing
`rex-navigator.nvim` before reloading Rex. Do not use a full plugin update just
to install this integration.

The companion loads from `$XDG_DATA_HOME/nvim/lazy/rex-navigator.nvim`, falling
back to `$HOME/.local/share/nvim/lazy/rex-navigator.nvim`. If it is missing, Rex
logs a warning and keeps the other bindings. A custom Lazy root or `NVIM_APPNAME`
requires updating the companion path in `init.lua`; the Rex app must inherit
the same `XDG_DATA_HOME` as Neovim.

Run `rex config check`, then `rex config reload`, and restart existing Neovim
instances. Inside Neovim in Rex, run `:checkhealth rex-navigator`.

`Ctrl-h/j/k/l` moves through Neovim splits before handing focus to Rex. In
other programs it moves directly between Rex panes, reserving those keys
instead of passing them to the program. Both halves wrap at the outer edge
by default. The existing `Ctrl-a`, then `h/l` tab bindings are unchanged.

The integration requires Neovim 0.10+, the Rex CLI, and compatible `ps` on the
Rex server. Normal and terminal modes are supported; insert mode, SSH-hosted
Neovim, and nested tmux/Rex sessions are not supported. The plugin is early-stage
and depends on Rex APIs that may change.

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
  tmux-fzf-links, and catppuccin-tmux are not migrated. `rex-navigator.nvim`
  replaces the basic directional navigation from vim-tmux-navigator, but does
  not provide previous-pane toggling, auto-save, or zoom preservation.
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
versions are installed. The keymap's diagnostics must be empty.

The navigation setup was checked and reloaded on macOS with Rex Beta 1758 and
`rex-navigator.nvim` commit `69c0351`. Rex reported all four navigation actions
and bindings with no diagnostics. Headless Neovim checks covered four-direction
split navigation and scoped edge handoffs with a stubbed Rex CLI, terminal
mappings, plugin health, LazyVim mapping ownership, and separate tmux/plain-terminal
behavior. The plugin's upstream behavior tests also passed. Interactive keypresses
in the Rex app and Linux behavior were not verified.
