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

  -- Helm
  "helm_ls",

  -- Groovy / Jenkins
  "groovyls",

  -- Ruby
  "solargraph",
}

-- Import-resolution support for nx-style UV monorepos (apps/* and libs/* are
-- each standalone UV projects, wired together by editable path dependencies).
--
-- basedpyright resolves imports statically and does not execute the interpreter,
-- read .pth files, or follow the import hooks that PEP 660 editable installs
-- register. Left alone it reports "could not be resolved" for every cross-package
-- import, which breaks go-to-definition. So we discover the real source trees
-- ourselves and hand them over as analysis.extraPaths.

-- Turn a file:// URL from a dist-info direct_url.json into a filesystem path.
local function file_url_to_path(url)
  local path = url:gsub("^file://", "")
  return (path:gsub("%%(%x%x)", function(hex)
    return string.char(tonumber(hex, 16))
  end))
end

-- A src-layout package puts its modules under <project>/src; a flat-layout one
-- puts them at the project root. Prefer src when it exists.
local function import_root(project_dir)
  local src = project_dir .. "/src"
  return vim.uv.fs_stat(src) and src or project_dir
end

-- Source 1: the venv. Catches transitive path dependencies, which only show up
-- once something has actually been installed.
local function venv_editable_paths(venv)
  local paths = {}
  for _, site_packages in ipairs(vim.fn.glob(venv .. "/lib/python*/site-packages", false, true)) do
    for _, dist_info in ipairs(vim.fn.glob(site_packages .. "/*.dist-info", false, true)) do
      local f = io.open(dist_info .. "/direct_url.json", "r")
      if f then
        local content = f:read "*a"
        f:close()
        local url = content:match '"editable"%s*:%s*true' and content:match '"url"%s*:%s*"([^"]+)"'
        if url and url:match "^file://" then
          table.insert(paths, import_root(file_url_to_path(url)))
        end
      end
    end
  end
  return paths
end

-- Source 2: [tool.uv.sources] in pyproject.toml. Needed because a standalone lib
-- in libs/ often has no .venv of its own -- only apps get synced -- and without
-- this, navigating from one lib into another resolves nothing.
--
-- Recurses so a chain of libs resolves, with a depth cap and a seen-set as the
-- guard against cyclic path dependencies.
local function uv_source_paths(project_dir, paths, seen, depth)
  paths, seen, depth = paths or {}, seen or {}, depth or 0
  if depth > 4 or seen[project_dir] then return paths end
  seen[project_dir] = true

  local f = io.open(project_dir .. "/pyproject.toml", "r")
  if not f then return paths end
  local content = f:read "*a"
  f:close()

  -- Isolate the [tool.uv.sources] table so `path = ...` keys belonging to other
  -- sections (e.g. [tool.hatch...]) are not picked up.
  local section = content:match "\n%s*%[tool%.uv%.sources%]%s*\n(.-)\n%s*%[" or content:match "\n%s*%[tool%.uv%.sources%]%s*\n(.*)$"
  if not section then return paths end

  for rel in section:gmatch 'path%s*=%s*"([^"]+)"' do
    local dep = vim.fs.normalize(rel:match "^/" and rel or (project_dir .. "/" .. rel))
    if vim.uv.fs_stat(dep) then
      table.insert(paths, import_root(dep))
      uv_source_paths(dep, paths, seen, depth + 1)
    end
  end
  return paths
end

-- The pristine extraPaths, resolved against whatever the project root is.
-- before_init always rebuilds from this constant rather than appending to
-- whatever is currently in settings, so one project's discovered paths cannot
-- accumulate into the next client's.
local base_extra_paths = { ".", "src" }

-- Configure basedpyright with standard type checking and performance optimizations
vim.lsp.config.basedpyright = {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  -- Flat lists carry no priority: Neovim picks the *nearest* ancestor holding
  -- any of these. That is what we want here -- it anchors at the individual
  -- app/lib rather than climbing to the monorepo root -- with .git last so it
  -- only applies when nothing more specific exists.
  root_markers = { "uv.lock", "pyrightconfig.json", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
  before_init = function(_, config)
    local root = config.root_dir
    if not root then return end

    -- Assign into the existing settings tables. Replacing config.settings
    -- wholesale does not propagate -- the client keeps the original reference
    -- and none of this would reach the server.

    -- Prefer a venv at the project root, then the nearest one above it (a
    -- workspace may keep a single shared venv), then an active $VIRTUAL_ENV.
    local venv = vim.fs.find(".venv", { path = root, upward = true, type = "directory", limit = 1 })[1]
    if not (venv and vim.uv.fs_stat(venv .. "/bin/python")) then
      venv = vim.env.VIRTUAL_ENV
    end

    if venv and vim.uv.fs_stat(venv .. "/bin/python") then
      -- basedpyright reads the interpreter from `python.pythonPath`. The
      -- `basedpyright.pythonPath` key it is often written to is silently ignored.
      config.settings.python = { pythonPath = venv .. "/bin/python" }
    end

    local discovered = venv and venv_editable_paths(venv) or {}
    vim.list_extend(discovered, uv_source_paths(root))

    local merged, seen = {}, {}
    for _, p in ipairs(vim.list_extend(vim.deepcopy(base_extra_paths), discovered)) do
      if not seen[p] then
        seen[p] = true
        table.insert(merged, p)
      end
    end
    config.settings.basedpyright.analysis.extraPaths = merged
  end,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        -- Rebuilt per-project in before_init; see base_extra_paths above.
        extraPaths = vim.deepcopy(base_extra_paths),
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
