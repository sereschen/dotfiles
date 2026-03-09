return {
  "stevearc/overseer.nvim",
  opts = {},
  config = function()
    require("overseer").setup({
      templates = {
        "builtin",
        {
          name = "eslint-trouble",
          cmd = { "npm" },
          args = { "run", "lint" },
          components = {
            "default",
            "on_result_diagnostics_trouble",
          },
        },
      },
    })
  end,
}
