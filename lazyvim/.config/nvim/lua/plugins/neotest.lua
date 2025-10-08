return {
  "nvim-neotest/neotest",
  keys = {
    {
      "<leader>tc",
      function()
        require("neotest").output_panel.clear()
      end,
    },
  },
}
