return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  ft = "markdown",
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/obsidian/sereschen@gmail.com/",
      },
    },

    -- see below for full list of options 👇
  },
}
