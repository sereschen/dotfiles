-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Next tab" })
vim.keymap.set('n', 'J', '<Nop>', { silent = true })

vim.keymap.set('n', 'q', '<Nop>', { silent = true })

vim.keymap.set("n", "<leader>gww", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
  { desc = "List Git Worktrees" })
vim.keymap.set("n", "<leader>gwn", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
  { desc = "Create Git Worktree" })

vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
vim.keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jk" })
