return {
  "nvim-neotest/neotest",
  dependencies = {
    {
      "arthur944/neotest-bun",
      rocks = {
        hererocks = true, -- Use hererocks to manage Lua 5.1
      },
    },
    "marilari88/neotest-vitest",
    {
      "thenbe/neotest-playwright",
      dependencies = "nvim-telescope/telescope.nvim",
    },
  },

  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest"),
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            get_playwright_config = function()
              return vim.loop.cwd() .. "/playwright.config.ts"
            end,
          },
        }),
        require("neotest-bun"),
      },
    })
  end,
  keys = {
    {
      "<leader>tc",
      function()
        require("neotest").output_panel.clear()
      end,
    },
  },
}
