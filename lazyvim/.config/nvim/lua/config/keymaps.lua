-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Next tab" })
vim.keymap.set('n', 'J', '<Nop>', { silent = true })
