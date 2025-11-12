require("nvchad.configs.lspconfig").defaults()

local servers = {
  -- Web
  "html",
  "cssls",

  -- Python
  "basedpyright",

  -- Go
  "gopls",

  -- TypeScript/JavaScript
  "vtsls",

  -- Svelte
  "svelte",

  -- Markup
  "jsonls",
  "yamlls",
  "marksman",

  -- Lua
  "lua_ls",

  -- Shell
  "bashls",

  -- Docker
  "dockerls",
  "docker_compose_language_service",
}

-- Configure basedpyright with standard type checking
vim.lsp.config.basedpyright = {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
      },
    },
  },
}

vim.lsp.enable(servers)
