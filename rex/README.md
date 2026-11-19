# Rex Module

Rex configuration with tmux-like `Ctrl-a` sequences. This package is independent
of the Ghostty and tmux packages and does not modify their configurations.

## Stow

From the root of this repository, run:

```bash
stow --simulate --verbose --target="$HOME" rex
stow --verbose --target="$HOME" rex
```

This links `init.lua` and `ports.lua` into `~/.config/rex/`. Only the hidden
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
| `p` | Pick a local TCP listener, then stop it or open its working directory |
| `t` | Pick a Git worktree and open or switch to its Rex session running Pi |
| `v` | Enter native vi-style copy mode |
| `Ctrl-a` | Send `Ctrl-a` through to the terminal |
| `h` / `l` | Previous / next tab |
| `1`–`9` | Select tab by index |
| `r` | Reload the Rex configuration |
| `w` | New tab |
| `z` | Toggle pane zoom |
| `-` | Split down |
| `Shift-\` (`\|`) | Split right |
| `j` / `k` | Focus the pane below / above |
| `c` | Close the current pane, including its tab when it is the last pane |
| `,` / `.` | Resize left / right with amount 20 |
| `=` | Resize up with amount 7 |
| `Ctrl-r` | Enter the exclusive repeat mode |

In repeat mode, `,`, `.`, and `=` resize without the prefix. Press Enter or
Escape to leave. This is not tmux's timed repeat behavior; other keys are
suppressed while this mode is active.

## Worktree picker

Press `Ctrl-a`, then `t` from a terminal inside a Git repository, or choose
**Open Worktree in Pi…** in the palette. The picker shows existing worktrees
for that repository, including their branches and full paths. Escape exits
without making changes. Selecting a worktree opens a Rex session with Pi in
that directory. The session name includes a short key derived from the full path,
so worktrees with the same folder name get separate sessions. Keep the generated
session name unchanged to reuse it on subsequent picks. The picker does not
create or delete Git worktrees or manage PRs; those actions stay in Lazyworktree.

This needs a Rex server and app that support custom UI (control API revision 17
or newer), Git on the server's `PATH`, and `pi` on the terminal shell's `PATH`.
Run it from a terminal on the local Rex server. Rex shows custom prompts on every
eligible connected app, and the first answer or cancellation wins.

## Vi copy mode

Press `Ctrl-a`, then `v` to enter Rex's native copy mode. Move through
scrollback with `h/j/k/l`, press `v` for a character selection (or `Shift-v`
for lines), and press `y` to copy to the clipboard and exit. Press Escape or
`q` to exit without copying. The default Mac shortcut `Cmd-Shift-C` still works.

## Closing panes

`Ctrl-a`, then `c` runs the `close_pane` action, which closes the invoking pane
through Rex's server API. Closing the last pane also closes its tab, matching
the tmux binding. This ends the program in that pane without a confirmation
prompt. Other panes and tabs are not closed.

Rex's native `pane.close` action is unavailable for a tab's only pane; binding
it directly lets the `c` key fall through to terminal input in that case. The
custom action avoids that restriction and explicitly targets the invoking
session and pane rather than whichever pane the app focuses later.

## Ports picker

Press `Ctrl-a`, then `p` (or choose **Open Ports Picker** in the palette) and
filter for a port such as `3000`. Each row shows the port, process, PID, and
working directory when readable. The picker includes visible TCP listeners on
the local Rex server, even if they are running in the background or outside Rex.

Selecting a listener opens an action menu. **Stop Process (SIGTERM)** is
available for listeners owned by the non-root Rex server account. It rechecks
the listener, owner, command, and start time before signaling the selected PID.
The check and signal are separate operations, so this cannot rule out PID reuse
between them. **Open Directory in a New Tab** opens its working directory without
stopping it. Escape from either menu makes no changes. Both menus can appear on
other connected apps, just like the worktree picker. If a supervisor restarts a
process, stopping the listener may not keep the port free.

This requires `lsof` and `ps` on the Rex server's `PATH`. It does not require
Television and has been verified only on macOS. The `tv ports` channel remains
available in tmux and Ghostty.

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
  and sending the `clear` command are not migrated.
- The home-directory-specific new-window binding is not migrated. The ordinary
  new-tab binding does not explicitly set a working directory.
- The native Worktrees and Ports pickers do not copy Television's preview UI
  or per-row shortcuts. The `o` binding still opens Rex's own session picker
  instead of the Sesh television channel.
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

The close action was checked and reloaded on macOS with Rex Beta 1758. A live
smoke test closed disposable split and floating panes, then the last pane in
a disposable tab, while preserving all original panes and the active tab.
The loaded keymap registered `Ctrl-a>c` with no diagnostics. Physical shortcut
keypresses were not exercised.

The navigation setup was checked and reloaded on macOS with Rex Beta 1758 and
`rex-navigator.nvim` commit `69c0351`. Rex reported all four navigation actions
and bindings with no diagnostics. Headless Neovim checks covered four-direction
split navigation and scoped edge handoffs with a stubbed Rex CLI, terminal
mappings, plugin health, LazyVim mapping ownership, and separate tmux/plain-terminal
behavior. The plugin's upstream behavior tests also passed. Interactive keypresses
in the Rex app and Linux behavior were not verified.
