local lint = require "lint"

-- Configure linters by filetype
lint.linters_by_ft = {
  python = { "ruff" },
  markdown = { "markdownlint-cli2" },
  dockerfile = { "hadolint" },
  sh = { "shellcheck" },
}

-- Markdownlint config
lint.linters["markdownlint-cli2"].args = {
  "--config",
  vim.fn.expand "~/.markdownlint-cli2.yaml",
}

-- Auto-lint on events
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})

return lint
