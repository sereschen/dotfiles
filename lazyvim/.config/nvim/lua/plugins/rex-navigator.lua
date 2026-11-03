return {
  "baggiponte/rex-navigator.nvim",
  main = "rex-navigator",
  lazy = false,
  cond = vim.env.REX_SESSION ~= nil and vim.env.REX_SESSION ~= "",
  opts = {},
  keys = {
    { "<c-h>", "<Plug>(RexNavigateLeft)", remap = true, desc = "Navigate left (Neovim/Rex)" },
    { "<c-j>", "<Plug>(RexNavigateDown)", remap = true, desc = "Navigate down (Neovim/Rex)" },
    { "<c-k>", "<Plug>(RexNavigateUp)", remap = true, desc = "Navigate up (Neovim/Rex)" },
    { "<c-l>", "<Plug>(RexNavigateRight)", remap = true, desc = "Navigate right (Neovim/Rex)" },
  },
}
