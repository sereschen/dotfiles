rex-tunnel() (
  emulate -L zsh

  if [[ -z "$REX_TUNNEL_HOST" || -z "$REX_TUNNEL_REMOTE_SOCKET" ]]; then
    print -u2 'Set REX_TUNNEL_HOST and REX_TUNNEL_REMOTE_SOCKET in a *.local.zsh file under ~/.zshrc.d/.'
    return 1
  fi

  local socket="${REX_TUNNEL_SOCKET:-$HOME/.ssh/rex-studio.sock}"
  local owners
  local -i lock_fd check_status

  umask 077
  command mkdir -p -m 700 "${socket:h}" || return
  : >> "$socket.lock" || return
  zmodload zsh/system || return
  if ! zsystem flock -t 0 -f lock_fd "$socket.lock"; then
    print -u2 'A rex-tunnel command is already running for this socket.'
    return 1
  fi

  if [[ -L "$socket" || ( -e "$socket" && ! -S "$socket" ) ]]; then
    print -u2 "Refusing to replace a non-socket path: $socket"
    return 1
  fi

  if [[ -S "$socket" ]]; then
    owners=$(command lsof -t -- "$socket" 2>&1)
    check_status=$?
    if (( check_status == 0 )); then
      print -u2 "A process already owns $socket. Leave that tunnel running or close it before reconnecting."
      return 1
    elif (( check_status != 1 )) || [[ -n "$owners" ]]; then
      print -u2 "Could not check the socket safely: $owners"
      return 1
    fi
  fi

  print "Connecting to $REX_TUNNEL_HOST. Leave this terminal open; Ctrl-C disconnects."
  command ssh -N \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 \
    -o ServerAliveCountMax=3 \
    -o StreamLocalBindUnlink=yes \
    -L "$socket:$REX_TUNNEL_REMOTE_SOCKET" \
    "$REX_TUNNEL_HOST"
)
