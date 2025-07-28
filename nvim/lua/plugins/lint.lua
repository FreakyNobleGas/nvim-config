-- Configures the default linter for LazyVim to look at a specific configuration file.
--
-- The syntax for the configuration file is:
-- config:
--  MD013: false
--

local HOME = os.getenv("HOME")
vim.g.vim_svelte_plugin_load_full_syntax = 1
vim.g.vim_svelte_plugin_use_typescript = 1
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", HOME .. "/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
  {
    "leafOfTree/vim-svelte-plugin",
    ft = { "svelte" },
  },
}
