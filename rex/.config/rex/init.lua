rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("ctrl+a>o", "session.switch")
rex.bind("ctrl+a>v", "pane.copy_mode.enter")
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

require("ports")

local terminal = "com.superlogical.terminal"

local function worktree_git(args, cwd, stdin)
  local result, err = rex.exec(args, { cwd = cwd, stdin = stdin, timeout = 3 })
  if not result then error(err, 0) end
  if not result.ok then
    error(result.timed_out and "Git timed out" or result.stderr, 0)
  end
  return result.stdout
end

rex.action({
  name = "open_worktree",
  title = "Open Worktree in Pi…",
  run = function(ctx)
    if not ctx.block_id or not ctx.client_id or ctx.server then
      error("Open Worktree needs a terminal pane on the local Rex server", 0)
    end
    local source = assert(rex.session.describe_block({ block_id = ctx.block_id })).block
    local server = assert(rex.call("server.status"))
    if source.creator_name ~= terminal or source.host_id ~= server.host_id then
      error("Open Worktree needs a terminal on this Rex server", 0)
    end
    local process = assert(rex.block.call(terminal, "process", { block_id = ctx.block_id }))
    local cwd = process.foreground and process.foreground.cwd
    if not cwd then error("Rex could not read the foreground process's directory", 0) end

    local common_dir_args = { "git", "rev-parse", "--path-format=absolute", "--git-common-dir" }
    local common_dir = worktree_git(common_dir_args, cwd)
    local listing = worktree_git({ "git", "worktree", "list", "--porcelain", "-z" }, cwd)
    local items = {}
    for record in listing:gmatch("(.-)%z%z") do
      local path = record:match("^worktree ([^%z]+)")
      local fields = record .. "\0"
      if path and not fields:find("\0bare\0", 1, true) and not fields:find("\0prunable ", 1, true) then
        items[#items + 1] = {
          id = path,
          title = fields:match("%zbranch refs/heads/([^%z]+)") or "Detached HEAD",
          subtitle = path,
          icon = "branch",
        }
        if #items == 2000 then break end
      end
    end
    if #items == 0 then error("No available Git worktrees in this repository", 0) end

    local path, why, detail = rex.ui.pick({ title = "Open Worktree in Pi", items = items })
    if not path then
      if why == "cancelled" then return end
      error("Worktree picker: " .. why .. (detail and (": " .. detail) or ""), 0)
    end
    local root = worktree_git({ "git", "rev-parse", "--show-toplevel" }, path):gsub("\n$", "")
    if root ~= path or worktree_git(common_dir_args, path) ~= common_dir then
      error("The selected path is no longer a worktree for this repository: " .. path, 0)
    end

    local key = worktree_git({ "git", "hash-object", "--stdin" }, path, path):sub(1, 12)
    local name = path:match("([^/]+)$"):gsub("%c", " "):match("^%s*(.-)%s*$")
    if name == "" or #name > 113 then name = "Worktree" end
    local label = name .. " [" .. key .. "]"
    for _, session in ipairs(assert(rex.call("session.list")).sessions or {}) do
      if session.label == label then
        rex.client.queue("session.select", { session_id = session.session_id })
        return
      end
    end

    local session = assert(rex.call("session.create", {
      label = label,
      initial_windows = {{
        window_label = "ai",
        layout = rex.layout.block({
          flavor = terminal .. ".shell",
          options = { cwd = path, command = { "pi" }, interactive = true },
        }),
      }},
    }))
    rex.client.queue("session.select", { session_id = session.session_id })
  end,
})
rex.bind("ctrl+a>t", "open_worktree")

rex.bind("ctrl+a>h", "client.tab.previous")
rex.bind("ctrl+a>l", "client.tab.next")
rex.bind("ctrl+a>1", "client.tab.goto", { index = 1 })
rex.bind("ctrl+a>2", "client.tab.goto", { index = 2 })
rex.bind("ctrl+a>3", "client.tab.goto", { index = 3 })
rex.bind("ctrl+a>4", "client.tab.goto", { index = 4 })
rex.bind("ctrl+a>5", "client.tab.goto", { index = 5 })
rex.bind("ctrl+a>6", "client.tab.goto", { index = 6 })
rex.bind("ctrl+a>7", "client.tab.goto", { index = 7 })
rex.bind("ctrl+a>8", "client.tab.goto", { index = 8 })
rex.bind("ctrl+a>9", "client.tab.goto", { index = 9 })
rex.bind("ctrl+a>r", "client.config.reload")
rex.bind("ctrl+a>w", "client.tab.new")
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>shift+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.action({
  name = "close_pane",
  title = "Close Pane Including Last",
  run = function(ctx)
    local result, err = rex.call("block.close", {
      session_id = ctx.session_id,
      block_id = ctx.block_id,
    })
    if err then error(err, 0) end
    return result
  end,
})
rex.bind("ctrl+a>c", "close_pane")

rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+a>ctrl+r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")
rex.bind("ctrl+a>,", "pane.resize", { amount = 20, direction = "left" })
rex.bind("repeat/,", "pane.resize", { amount = 20, direction = "left" })
rex.bind("ctrl+a>.", "pane.resize", { amount = 20, direction = "right" })
rex.bind("repeat/.", "pane.resize", { amount = 20, direction = "right" })
rex.bind("ctrl+a>=", "pane.resize", { amount = 7, direction = "up" })
rex.bind("repeat/=", "pane.resize", { amount = 7, direction = "up" })

local data = os.getenv("XDG_DATA_HOME")
if not data or data == "" then
  data = os.getenv("HOME") .. "/.local/share"
end
local plugin = data .. "/nvim/lazy/rex-navigator.nvim"
local ok, err = pcall(function()
  dofile(plugin .. "/rex/navigator.lua").setup()
end)
if not ok then
  rex.log("warn", "rex-navigator not loaded: " .. tostring(err))
end
