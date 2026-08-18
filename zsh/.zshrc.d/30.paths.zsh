# Ensure Homebrew is available to non-login shells such as tmux panes without
# running `brew shellenv` during every shell startup.
if [[ "$OSTYPE" == "darwin"* ]] && [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
  export HOMEBREW_CELLAR=/opt/homebrew/Cellar
  export HOMEBREW_REPOSITORY=/opt/homebrew
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
  typeset -U path PATH
fi

# macOS-specific paths for OpenSSL and PostgreSQL.
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/usr/local/opt/openssl/bin:$PATH"
  export PATH="/usr/local/opt/postgresql@14/bin:$PATH"
  export LDFLAGS="-L/usr/local/opt/postgresql@14/lib"
  export CPPFLAGS="-I/usr/local/opt/postgresql@14/include"
  export PKG_CONFIG_PATH="/usr/local/opt/postgresql@14/lib/pkgconfig"
fi

# Bun - optional
if [ -d "$HOME/.bun" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Yarn Classic global binaries - optional
if [[ -d "$HOME/.yarn/bin" ]] && [[ ":$PATH:" != *":$HOME/.yarn/bin:"* ]]; then
  export PATH="$HOME/.yarn/bin:$PATH"
fi

# Pyenv - optional
if command -v pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
fi

# Go - optional
if command -v go &> /dev/null; then
  export GOPATH="${GOPATH:-$HOME/go}"
  export GOBIN="$GOPATH/bin"
  export PATH="$PATH:$GOBIN"
fi

# Local bin env - optional
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# macOS-specific Metal and LM Studio configuration.
if [[ "$OSTYPE" == "darwin"* ]]; then
  export MTL_LANGUAGE_REVISION=Metal24
  export PATH="$PATH:/Users/sergio/.lmstudio/bin"
fi

# Added by Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# Add ~/.local/bin to PATH for devin.
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
