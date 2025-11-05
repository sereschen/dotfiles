return {
  "nvim-neotest/neotest",
  dependencies = {
    {
      "arthur944/neotest-bun",
      rocks = {
        hererocks = true, -- Use hererocks to manage Lua 5.1
      },
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
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
