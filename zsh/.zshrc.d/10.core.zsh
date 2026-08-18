setopt prompt_subst
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Register completion directories before compinit so it only needs to run once.
[[ -d /opt/homebrew/share/zsh/site-functions ]] && fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
[[ -d "$HOME/.zsh/completions" ]] && fpath=("$HOME/.zsh/completions" $fpath)

autoload -Uz compinit bashcompinit
# Reuse the completion dump instead of repeating compinit's security scan in
# every pane. Remove ~/.zcompdump after installing new completion definitions.
compinit -C
bashcompinit
