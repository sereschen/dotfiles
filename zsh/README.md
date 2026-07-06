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
| `.zshrc.d/60.keybindings.zsh` | Vi-mode binds, FZF_DEFAULT_COMMAND |
| `.zshrc.d/99999.needs-to-be-last.zsh` | Zoxide init (must be last to override `cd`) |

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

### Optional (non-brew)
- `nvm` — Node version manager (curl installer)
- `bun` — JS runtime (curl installer)
- `pyenv` — Python version manager (brew or git)
