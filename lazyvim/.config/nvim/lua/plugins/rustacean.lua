return {
  "mrcjkb/rustaceanvim",
  opts = function(_, opts)
    opts = opts or {}
    local local_opts = opts
    local path = { "server", "default_settings", "rust-analyzer", "procMacro", "ignored" }

    for i = 1, #path - 1 do
      local_opts[path[i]] = local_opts[path[i]] or {}
      local_opts = local_opts[path[i]]
    end
    local_opts[path[#path]] = {
      ["napi-derive"] = { "napi" },
      ["async-recursion"] = { "async_recursion" },
    }

    return opts
  end,
}
