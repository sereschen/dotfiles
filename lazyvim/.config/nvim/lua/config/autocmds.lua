-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

if vim.env.TMUX then
  local session = vim.fn.system("tmux display-message -p '#S'"):gsub("%s+", "")
  local pane = vim.env.TMUX_PANE or "unknown"
  local sock = ("/tmp/nvim-tmux-%s-%s.sock"):format(session, pane:gsub("%%", ""))
  pcall(vim.fn.serverstart, sock)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("tmux_nvim_server_cleanup", { clear = true }),
    callback = function()
      pcall(os.remove, sock)
    end,
  })
end
