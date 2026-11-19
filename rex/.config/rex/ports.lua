local function run(argv, empty_ok)
  local result, err = rex.exec(argv, { timeout = 4, env = { LC_ALL = "C" } })
  if not result then error(err, 0) end
  if result.ok or (empty_ok and result.code == 1 and result.stderr == "") then
    return result.stdout
  end
  if result.timed_out then error(argv[1] .. " timed out", 0) end
  error(result.stderr ~= "" and result.stderr or (argv[1] .. " failed"), 0)
end

local function listeners(port, target_pid)
  local argv = { "lsof", "-nP", "-w", "-a", "-iTCP" .. (port and (":" .. port) or ""),
    "-sTCP:LISTEN", "-F0pucn" }
  if target_pid then
    argv[#argv + 1] = "-p"
    argv[#argv + 1] = target_pid
  end
  local rows, seen = {}, {}
  local pid, owner, command
  for field, value in run(argv, true):gmatch("\n?(%a)([^%z]*)%z") do
    if field == "p" then
      pid, owner, command = value:match("^[1-9]%d*$"), nil, nil
    elseif field == "u" then
      owner = value:match("^%d+$")
    elseif field == "c" then
      command = value
    elseif field == "n" and pid then
      local n = tonumber(value:match(":(%d+)$"))
      local id = n and (n .. ":" .. pid)
      if id and not seen[id] then
        seen[id] = true
        rows[#rows + 1] = { id = id, port = n, pid = pid, uid = owner, command = command }
      end
    end
  end
  return rows
end

local function directories(pids)
  local dirs, pid = {}, nil
  local output = run({ "lsof", "-nP", "-w", "-a", "-p", pids, "-d", "cwd", "-F0pn" }, true)
  for field, value in output:gmatch("\n?(%a)([^%z]*)%z") do
    if field == "p" then pid = value end
    if field == "n" and pid and value:sub(1, 1) == "/" then dirs[pid] = value end
  end
  return dirs
end

local function process_starts(pids)
  local starts = {}
  local output = run({ "ps", "-p", pids, "-o", "pid=", "-o", "lstart=" }, true)
  for line in output:gmatch("[^\n]+") do
    local pid, start = line:match("^%s*(%d+)%s+(.-)%s*$")
    if pid and start ~= "" then starts[pid] = start end
  end
  return starts
end

local function pick(options)
  local answer, why, detail = rex.ui.pick(options)
  if not answer and why ~= "cancelled" then
    error("Ports picker: " .. why .. (detail and (": " .. detail) or ""), 0)
  end
  return answer
end

rex.action({
  name = "ports",
  title = "Open Ports Picker",
  run = function(ctx)
    if ctx.server then error("Open Ports lists listeners on the local Rex server", 0) end
    local uid = run({ "id", "-u" }):match("^%s*(%d+)%s*$")
    local rows = listeners()
    table.sort(rows, function(a, b)
      if a.port == b.port then return tonumber(a.pid) < tonumber(b.pid) end
      return a.port < b.port
    end)
    local items, by_id, pids, seen = {}, {}, {}, {}
    local limit = math.min(#rows, 2000)
    for i = 1, limit do
      local row = rows[i]
      by_id[row.id] = row
      if not seen[row.pid] then
        pids[#pids + 1], seen[row.pid] = row.pid, true
      end
    end
    if #pids == 0 then error("No visible TCP listeners on this Rex server", 0) end
    local selection = table.concat(pids, ",")
    local dirs, starts = directories(selection), process_starts(selection)
    for i = 1, limit do
      local row = rows[i]
      local dir = dirs[row.pid]
      items[i] = {
        id = row.id,
        title = row.port .. " · " .. (row.command or "Unknown process"),
        subtitle = dir or "Working directory unavailable",
        detail = "PID " .. row.pid,
        icon = "server",
      }
    end
    local selected = pick({ title = "Listening TCP ports", placeholder = "Filter by port or process", items = items })
    if not selected then return end

    local row = by_id[selected]
    local dir, start = dirs[row.pid], starts[row.pid]
    local actions = {}
    if dir and ctx.session_id then
      actions[#actions + 1] = { id = "open", title = "Open Directory in a New Tab", subtitle = dir, icon = "folder" }
    end
    if uid and uid ~= "0" and row.uid == uid and start then
      actions[#actions + 1] = {
        id = "stop", title = "Stop Process (SIGTERM)", subtitle = dir, detail = "PID " .. row.pid, icon = "terminal",
      }
    end
    if #actions == 0 then error("The directory or process is not accessible to this Rex server account", 0) end
    local action = pick({ title = row.port .. " · " .. (row.command or "Unknown process"), items = actions })
    if action == "open" then
      run({ "test", "-d", dir })
      return assert(rex.session.new_window({
        layout = rex.layout.block({
          flavor = "com.superlogical.terminal.shell",
          options = { cwd = dir },
        }),
      }))
    elseif action == "stop" then
      local current = listeners(row.port, row.pid)[1]
      if not current or current.id ~= row.id or current.uid ~= uid or current.command ~= row.command
        or process_starts(row.pid)[row.pid] ~= start then
        error("The selected listener changed; reopen Ports before stopping it", 0)
      end
      run({ "kill", "-TERM", row.pid })
    end
  end,
})
rex.bind("ctrl+a>p", "ports")
