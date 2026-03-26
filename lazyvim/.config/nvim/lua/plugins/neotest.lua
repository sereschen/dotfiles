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
    {
      "nvim-neotest/neotest-jest",
    },
  },

  config = function()
    -- vim.uv compatibility for different Neovim versions
    local uv = vim.uv or vim.loop

    -- Detect project root robustly using vim.fs.root with markers, fallback to cwd
    local root = vim.fs.root(0, { ".git", "package.json", "tsconfig.json", ".gitignore" })
      or uv.cwd()

    -- Helper function to check if any of the given files exist in the project root
    local function file_exists(files)
      for _, file in ipairs(files) do
        local path = root .. "/" .. file
        local stat = uv.fs_stat(path)
        if stat and stat.type == "file" then
          return true, path
        end
      end
      return false, nil
    end

    -- Build adapters list conditionally based on project config files
    local adapters = {}

    -- Vitest adapter: enabled if vitest.config.(ts/js/mts/mjs) exists
    local vitest_files = { "vitest.config.ts", "vitest.config.js", "vitest.config.mts", "vitest.config.mjs" }
    if file_exists(vitest_files) then
      table.insert(adapters, require("neotest-vitest"))
    end

    -- Playwright adapter: enabled if playwright.config.(ts/js/mts/mjs) exists
    local playwright_files = { "playwright.config.ts", "playwright.config.js", "playwright.config.mts", "playwright.config.mjs" }
    local has_playwright, playwright_path = file_exists(playwright_files)
    if has_playwright then
      table.insert(adapters, require("neotest-playwright").adapter({
        options = {
          persist_project_selection = true,
          enable_dynamic_test_discovery = true,
          get_playwright_config = function()
            return playwright_path
          end,
        },
      }))
    end

    -- Bun adapter: enabled if bun.lock or bun.lockb exists
    local bun_files = { "bun.lock", "bun.lockb" }
    if file_exists(bun_files) then
      table.insert(adapters, require("neotest-bun"))
    end

    -- Jest adapter: enabled if jest.config.(ts/js/mts/mjs/cjs) exists
    local jest_files = { "jest.config.ts", "jest.config.js", "jest.config.mts", "jest.config.mjs", "jest.config.cjs" }
    if file_exists(jest_files) then
      table.insert(adapters, require("neotest-jest"))
    end

    require("neotest").setup({
      adapters = adapters,
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
