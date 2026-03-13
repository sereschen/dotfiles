return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        shellcheck = {
          args = {
            "--shell=bash",
            "--format=json",
            "--exclude=SC2034", -- Ignore "variable appears unused" (noisy on .env files)
            "-",
          },
        },
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            '{"MD013": false}',
            "--",
          },
        },
      },
    },
  },
}
