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

  -- Groovy / Jenkins
  "groovyls",

  -- Ruby
  "solargraph",
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
        -- Add extra paths to match pytest.ini configuration
        extraPaths = {
          ".",
          "src/runtime",
          "tests/unit",
          "tests/infrastructure",
        },
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
          -- Reduce noise in test files
          reportMissingImports = "warning",
          reportPrivateUsage = "none",
        },
      },
      disableOrganizeImports = false,
    },
  },
}

vim.lsp.config.groovyls = {
  cmd = {
    "java",
    "--sun-misc-unsafe-memory-access=allow", -- suppress classgraph deprecation warning on Java 23+
    "-jar",
    vim.fn.stdpath("data") .. "/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
  },
  filetypes = { "groovy" },
  root_markers = { "Jenkinsfile", ".git" },
}

vim.lsp.enable(servers)
