-- Configures the default linter for LazyVim to look at a specific configuration file.
--
-- The syntax for the configuration file is:
-- config:
--  MD013: false
--

local HOME = os.getenv("HOME")
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
}
