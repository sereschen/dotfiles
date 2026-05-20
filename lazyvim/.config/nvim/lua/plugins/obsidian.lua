return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  cond = vim.fn.isdirectory(vim.fn.expand("~/obsidian/git/")) == 1,
  ft = "markdown",
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/obsidian/git/",
      },
    },
  },
}
