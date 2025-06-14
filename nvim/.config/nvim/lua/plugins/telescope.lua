return {
  "nvim-telescope/telescope.nvim",
  tag = '0.1.8',
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,                       -- move to prev result
              ["<C-j>"] = actions.move_selection_next,                           -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
            }
          }
        }
      })

    local keymap = vim.keymap -- for conciseness
    local builtin = require("telescope.builtin")
    keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find string under cursor in cwd" })

    -- Rip grep + Fzf
    vim.keymap.set('n', '<leader>fg', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") });
    end)

    -- Find instance instance of current view being included
    vim.keymap.set('n', '<leader>fc', function()
      local filename_without_extension = vim.fn.expand('%:t:r')
      builtin.grep_string({ search = filename_without_extension })
    end, { desc = "Find current file: " })

    -- Grep current string (for when gd doesn't work)
    vim.keymap.set('n', '<leader>fs', function()
      builtin.grep_string({})
    end, { desc = "Find current string: " })

    -- find files in vim config
    vim.keymap.set('n', '<leader>fi', function()
      builtin.find_files({ cwd = "~/.config/nvim/" });
    end)

  end
}
