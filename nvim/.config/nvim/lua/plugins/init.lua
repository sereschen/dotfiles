return {
  -- File Explorer
  {  
	"nvim-tree/nvim-tree.lua",
  },

  -- Autocompletion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
  'saadparwaiz1/cmp_luasnip', -- Snippet source for nvim-cmp
  'L3MON4D3/LuaSnip', -- Snippet engine

  -- LSP (Language Server Protocol)
  'neovim/nvim-lspconfig', -- Configurations for different language servers
  'williamboman/mason.nvim', -- Easily install LSP servers, formatters, linters
  'williamboman/mason-lspconfig.nvim', -- Connects mason with nvim-lspconfig

  -- Fuzzy Finder
  'nvim-telescope/telescope.nvim',
  'nvim-lua/plenary.nvim', -- Required by telescope

  -- Status Line
  'nvim-lualine/lualine.nvim',

  -- Git Integration
  'lewis6991/gitsigns.nvim',

  -- Syntax Highlighting
  'nvim-treesitter/nvim-treesitter',
  {
	  "catppuccin/nvim",
	  lazy = true,
	  name = "catppuccin",
	  opts = {
	    integrations = {
	      aerial = true,
	      alpha = true,
	      cmp = true,
	      dashboard = true,
	      flash = true,
	      fzf = true,
	      grug_far = true,
	      gitsigns = true,
	      headlines = true,
	      illuminate = true,
	      indent_blankline = { enabled = true },
	      leap = true,
	      lsp_trouble = true,
	      mason = true,
	      markdown = true,
	      mini = true,
	      native_lsp = {
		enabled = true,
		underlines = {
		  errors = { "undercurl" },
		  hints = { "undercurl" },
		  warnings = { "undercurl" },
		  information = { "undercurl" },
		},
	      },
	      navic = { enabled = true, custom_bg = "lualine" },
	      neotest = true,
	      neotree = true,
	      noice = true,
	      notify = true,
	      semantic_tokens = true,
	      snacks = true,
	      telescope = true,
	      treesitter = true,
	      treesitter_context = true,
	      which_key = true,
	    },
	  },
	  specs = {
    {
      "akinsho/bufferline.nvim",
      optional = true,
      opts = function(_, opts)
	if (vim.g.colors_name or ""):find("catppuccin") then
	  opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
	end
      end,
    },
	  },
}

}

