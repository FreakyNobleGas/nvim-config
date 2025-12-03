local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- Python - auto-detect formatter based on project config
    python = function(bufnr)
      -- Check if project has ufmt config in pyproject.toml
      local cwd = vim.fn.getcwd()
      local pyproject_path = cwd .. "/pyproject.toml"
      local handle = io.open(pyproject_path, "r")

      if handle then
        local content = handle:read("*all")
        handle:close()
        -- Check for ufmt configuration section
        if content:match("%[tool%.ufmt%]") or content:match("ufmt") then
          return { "ufmt" }
        end
      end

      -- Default to black if no ufmt config found
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
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
