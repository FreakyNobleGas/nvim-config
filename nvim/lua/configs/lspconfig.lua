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
  -- uv.lock is at the app root (alongside pyproject.toml) in UV projects.
  -- Listing it first ensures we anchor at the correct project boundary.
  root_markers = { "uv.lock", "pyrightconfig.json", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
  before_init = function(_, config)
    local root = config.root_dir
    local venv_python = root .. "/.venv/bin/python"
    if not vim.uv.fs_stat(venv_python) then return end

    -- Explicitly point basedpyright at the UV-managed venv.
    config.settings.basedpyright.pythonPath = venv_python

    -- Editable installs using setuptools PEP 660 register an import hook rather
    -- than adding a path to sys.path. basedpyright can't follow hooks statically,
    -- so read direct_url.json from each dist-info to find the real source root.
    local sp_dirs = vim.fn.glob(root .. "/.venv/lib/python*/site-packages", false, true)
    if #sp_dirs == 0 then return end

    local extra_paths = {}
    for _, dist_info in ipairs(vim.fn.glob(sp_dirs[1] .. "/*.dist-info", false, true)) do
      local f = io.open(dist_info .. "/direct_url.json", "r")
      if f then
        local content = f:read("*all")
        f:close()
        if content:match('"editable"%s*:%s*true') then
          local url = content:match('"url"%s*:%s*"([^"]+)"')
          if url and url:match("^file://") then
            local path = url:gsub("^file://", "")
            local src = path .. "/src"
            table.insert(extra_paths, vim.uv.fs_stat(src) and src or path)
          end
        end
      end
    end

    if #extra_paths > 0 then
      local analysis = config.settings.basedpyright.analysis
      analysis.extraPaths = vim.list_extend(analysis.extraPaths or {}, extra_paths)
    end
  end,
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
