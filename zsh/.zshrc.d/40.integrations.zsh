# Cache generated integration scripts. On this machine every subprocess pays a
# noticeable security-scanner penalty, so generating these in every pane adds
# several seconds. A cache is refreshed when the corresponding binary changes.
ZSH_INIT_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init"
[[ -d "$ZSH_INIT_CACHE_DIR" ]] || mkdir -p "$ZSH_INIT_CACHE_DIR"

_zsh_cache_init() {
  local tool=$1 cache_file=$2
  shift 2

  (( $+commands[$tool] )) || return 0
  if [[ ! -s "$cache_file" || "${commands[$tool]}" -nt "$cache_file" ]]; then
    "$@" >| "$cache_file" || return
  fi
  source "$cache_file"
}

_zsh_cache_init starship "$ZSH_INIT_CACHE_DIR/starship.zsh" starship init zsh

# macOS-specific setup with Homebrew. Use Homebrew's stable prefix directly to
# avoid spawning `brew --prefix` in every shell.
if [[ "$OSTYPE" == "darwin"* ]] && [[ -s /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

  # zsh-autosuggestions keybinds
  bindkey '^w' autosuggest-execute
  bindkey '^e' autosuggest-accept
  bindkey '^u' autosuggest-toggle
fi

# Loading nvm normally runs `nvm use`, whose many subprocesses take tens of
# seconds under the local endpoint scanner. Put the requested installed Node
# version on PATH with zsh builtins, then load nvm's functions without auto-use.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  typeset -a _nvm_versions
  typeset _nvm_default _nvm_selector _nvm_candidate _nvm_version_dir _nvm_search_dir

  if [[ -r "$NVM_DIR/alias/default" ]]; then
    IFS= read -r _nvm_default < "$NVM_DIR/alias/default"
  fi
  _nvm_selector=${_nvm_default#v}

  # Preserve nvm's startup behavior for simple numeric .nvmrc files.
  _nvm_search_dir=$PWD
  while [[ -n "$_nvm_search_dir" ]]; do
    if [[ -r "$_nvm_search_dir/.nvmrc" ]]; then
      IFS= read -r _nvm_selector < "$_nvm_search_dir/.nvmrc"
      _nvm_selector=${_nvm_selector#v}
      break
    fi
    [[ "$_nvm_search_dir" == / ]] && break
    _nvm_search_dir=${_nvm_search_dir:h}
  done

  _nvm_candidate="$NVM_DIR/versions/node/v$_nvm_selector"
  if [[ -d "$_nvm_candidate" ]]; then
    _nvm_versions=("$_nvm_candidate")
  else
    _nvm_versions=("$NVM_DIR"/versions/node/v${_nvm_selector}.*(N/n))
  fi
  (( ${#_nvm_versions} )) || _nvm_versions=("$NVM_DIR"/versions/node/v*(N/n))

  if (( ${#_nvm_versions} )); then
    _nvm_version_dir=${_nvm_versions[-1]}
    path=("$_nvm_version_dir/bin" $path)
    typeset -U path PATH
    export NVM_BIN="$_nvm_version_dir/bin"
    export NVM_INC="$_nvm_version_dir/include/node"
  fi

  source "$NVM_DIR/nvm.sh" --no-use
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  unset _nvm_versions _nvm_default _nvm_selector _nvm_candidate _nvm_version_dir _nvm_search_dir
fi

# Bun - optional
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Pyenv - optional
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi


# FZF - optional
_zsh_cache_init fzf "$ZSH_INIT_CACHE_DIR/fzf.zsh" fzf --zsh

# UV - optional
if command -v uv &> /dev/null; then
  eval "$(uv generate-shell-completion zsh)"
  eval "$(uvx --generate-shell-completion zsh)"
fi


if (( $+commands[sesh] )) && [[ ! -s "$HOME/.zsh/completions/_sesh" ]]; then
  mkdir -p "$HOME/.zsh/completions"
  sesh completion zsh >| "$HOME/.zsh/completions/_sesh"
fi

_zsh_cache_init tv "$ZSH_INIT_CACHE_DIR/tv.zsh" tv init zsh


