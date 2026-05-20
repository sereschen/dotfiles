# Ensure Homebrew is in PATH for non-login shells like tmux panes.
if [[ "$OSTYPE" == "darwin"* ]] && [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
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
