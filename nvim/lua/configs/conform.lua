local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- Python - auto-detect formatter based on project config
    python = function(bufnr)
      local cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h")
      local pyproject_path = vim.fs.find("pyproject.toml", { path = cwd, upward = true })[1]

      if pyproject_path then
        local handle = io.open(pyproject_path, "r")
        if handle then
          local content = handle:read "*all"
          handle:close()
          if content:match "%[tool%.ufmt%]" or content:match "ufmt" then
            return { "ufmt" }
          end
          if content:match "%[tool%.ruff%]" or content:match "%[tool%.ruff%.format%]" then
            return { "ruff_organize_imports", "ruff_format" }
          end
        end
      end

      return { "black" }
    end,
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

    -- Groovy / Jenkins
    groovy = { "npm_groovy_lint" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
