local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- Python
    python = { "ufmt", "black" },

    -- Web
    typescript = { "prettier" },
    javascript = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },

    -- Go
    go = { "gofumpt", "goimports" },

    -- Shell
    sh = { "shfmt" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
