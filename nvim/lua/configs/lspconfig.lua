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
  "marksman", -- Re-enabled: provides link validation alongside zk-nvim

  -- Lua
  "lua_ls",

  -- Shell
  "bashls",

  -- Docker
  "dockerls",
  "docker_compose_language_service",
}

-- Configure basedpyright with standard type checking and performance optimizations
vim.lsp.config.basedpyright = {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        -- Exclude common directories that slow down indexing
        exclude = {
          "**/node_modules",
          "**/__pycache__",
          "**/.*",
          "**/venv",
          "**/.venv",
          "**/env",
          "**/.env",
          "**/site-packages",
          "**/.pytest_cache",
          "**/.mypy_cache",
          "**/.ruff_cache",
          "**/dist",
          "**/build",
        },
        -- Limit workspace symbol search
        indexing = true,
        -- Performance optimizations
        diagnosticSeverityOverrides = {
          reportUnusedImport = "information",
          reportUnusedClass = "information",
          reportUnusedFunction = "information",
          reportUnusedVariable = "information",
        },
      },
      disableOrganizeImports = false,
    },
  },
}

vim.lsp.enable(servers)
