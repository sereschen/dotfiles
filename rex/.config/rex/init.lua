rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("ctrl+a>o", "session.switch")
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })

rex.action({
  name = "ports",
  title = "Open Ports Picker",
  run = function(ctx)
    local source, err = rex.session.describe_block({ block_id = ctx.block_id })
    if err then error(err, 0) end
    local layer, create_err = rex.session.new_layer({
      window_id = source.block.window_id,
      bounds = { 0.1, 0.15, 0.8, 0.7 },
      focus = true,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        options = {
          command = { "tv", "ports" },
          cwd = os.getenv("HOME"),
          exit = { on_completion = true },
        },
      }),
    })
    if create_err then error(create_err, 0) end
    return layer
  end,
})
rex.bind("ctrl+a>p", "ports")

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
rex.bind("ctrl+a>c", "pane.close")

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
