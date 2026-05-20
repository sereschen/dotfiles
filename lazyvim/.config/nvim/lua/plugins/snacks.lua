return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        hidden = true, -- for hidden files
        ignored = false, -- for .gitignore files
        sources = {
          files = {
            hidden = true,
            ignored = false,
          },
          grep = {
            hidden = true,
            ignored = false,
          },
        },
      },
      lazygit = {
        -- This merges with the default configuration
        config = {
          os = {
            -- Overrides the default 'nvim-remote' preset
            -- Sending the command back to nvim to 'edit' as a buffer
            edit = 'nvr --remote-send "<C-\\><C-n>:q<CR>:e {{filename}}<CR>"',
          },
        },
      },
    },
  },
}
