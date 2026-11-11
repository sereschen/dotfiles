# Zsh Module

Modular zsh configuration. The main `.zshrc` sources all `*.zsh` files from `~/.zshrc.d/` in lexical order.

## Stow

```bash
stow -d ~/dotfiles -t ~ zsh
```

This symlinks `.zshrc` → `~/.zshrc` and `.zshrc.d/` → `~/.zshrc.d/`.

## Config files

| File | Purpose |
|------|---------|
| `.zshrc` | Entry point — sources all `~/.zshrc.d/*.zsh` files |
| `.zshrc.d/00.local.env.zsh` | Local secrets (gitignored via `*.local.*`) |
| `.zshrc.d/10.core.zsh` | Completions, prompt_subst, case-insensitive matching |
| `.zshrc.d/20.env.zsh` | XDG, EDITOR, NVM_DIR |
| `.zshrc.d/30.paths.zsh` | Homebrew, pyenv, go, bun, local bin PATH entries |
| `.zshrc.d/40.integrations.zsh` | Tool init: starship, zsh-autosuggestions, nvm, fzf, uv, sesh, tv |
| `.zshrc.d/50.aliases.zsh` | Conditional aliases (bat→cat, eza→ls, tree→la) |
| `.zshrc.d/55.rex-tunnel.zsh` | Foreground SSH tunnel to a remote Rex socket |
| `.zshrc.d/60.keybindings.zsh` | Vi-mode binds, FZF_DEFAULT_COMMAND |
| `.zshrc.d/99999.needs-to-be-last.zsh` | Zoxide init (must be last to override `cd`) |

## Docker Desktop completions

`10.core.zsh` adds `$HOME/.docker/completions` to `fpath` when the directory
exists, before the shared `compinit` call. Docker Desktop supplies the completion
files; no separate initialization belongs in `.zshrc`. If Docker Desktop adds
its completion block there again, remove that duplicate block.

The shared initialization uses a cached completion dump. If Docker completions
are not recognized after first installing them, remove `~/.zcompdump` and open
a new shell to rebuild it.

## Rex SSH tunnel

Create a gitignored `~/.zshrc.d/51.rex-tunnel.local.zsh` on the connecting
machine, using your SSH destination and the remote socket path reported by
`rex server status`:

```zsh
REX_TUNNEL_HOST='user@personal-mac.local'
REX_TUNNEL_REMOTE_SOCKET='/Users/user/Library/Application Support/rex/server.sock'
```

Open a new shell, or load only these two files in an existing shell:

```zsh
source ~/.zshrc.d/51.rex-tunnel.local.zsh
source ~/.zshrc.d/55.rex-tunnel.zsh
rex-tunnel
```

The command stays in the foreground. Keep its terminal open; Ctrl-C disconnects
SSH without stopping the remote Rex sessions. If the host disconnects, wait for
SSH to exit, then run `rex-tunnel` again. It does not retry automatically.

The local socket defaults to `~/.ssh/rex-studio.sock`, so existing Rex host
entries keep working. Set `REX_TUNNEL_SOCKET` in the local file to override it.
SSH replaces stale sockets, but the helper refuses to replace regular files,
symlinks, or a socket that `lsof` reports is in use. A file lock prevents two
helper invocations from starting together. Do not start a separate manual tunnel
on the same socket while using this command; other commands do not share its lock.
The empty `.lock` file beside the socket remains between runs; its presence does
not mean a tunnel is running.

The remote machine must have Rex running and permit SSH login and forwarding.
Work-to-personal connections must also comply with your employer's device and
network policies. This helper forwards only a local Unix socket, not a Wi-Fi TCP
port. It requires OpenSSH with Unix-socket forwarding, `lsof`, and Zsh's
`zsh/system` module with `flock` support. Verification used isolated sockets on
macOS; Linux and a live remote connection were not verified.

## Dependencies

### Required (brew)
- `zsh`
- `starship` — prompt
- `zsh-autosuggestions` — sourced from brew prefix on macOS

### Optional (brew)
- `fzf` — fuzzy finder integration
- `fd` — used as FZF_DEFAULT_COMMAND
- `bat` — aliased to `cat`
- `eza` — aliased to `ls`
- `tree` — aliased to `la`
- `zoxide` — smart `cd` replacement
- `sesh` — tmux session manager (shell completions)
- `television` — tv channel picker
- OpenSSH and `lsof` — used by the optional `rex-tunnel` command

### Optional (non-brew)
- `nvm` — Node version manager (curl installer)
- `bun` — JS runtime (curl installer)
- `pyenv` — Python version manager (brew or git)
