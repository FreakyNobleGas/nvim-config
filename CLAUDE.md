# AI Context for nvim-config

This file provides persistent context and conventions for AI assistants working in this repo.

## Project Overview

This is a personal Neovim configuration using NvChad as the base framework.

## Code Style & Conventions

### Lua Coding Standards
- Use 2-space indentation
- Prefer local functions over global ones
- Follow NvChad's plugin structure conventions

### Configuration Structure
- Plugin configurations go in `nvim/lua/plugins/init.lua`
- Custom keymaps go in `nvim/lua/mappings.lua`
- LSP configurations go in `nvim/lua/configs/lspconfig.lua`
- Formatting rules go in `nvim/lua/configs/conform.lua`
- Linting rules go in `nvim/lua/configs/lint.lua`

## Tech Stack

### Languages & Tools
- **Languages**: Python, Go, TypeScript/JavaScript, Svelte, Bash, Lua
- **Formatters**: black, gofumpt, prettier, stylua, shfmt
- **LSP Servers**: basedpyright, gopls, vtsls, svelte-language-server
- **Note-taking**: ZK (Zettelkasten)

## Project-Specific Preferences

### When helping with config changes:
- Always maintain compatibility with NvChad conventions
- Prefer using NvChad's built-in functions when available
- Keep plugin lazy-loading where possible for faster startup
- Document keymaps with clear descriptions for which-key

### Plugin Management
- Use Lazy.nvim as the plugin manager
- Plugins should be lazy-loaded when appropriate
- Always specify dependencies explicitly

## Common Tasks

### Adding a new plugin
1. Add entry to `nvim/lua/plugins/init.lua`
2. Add keymaps to `nvim/lua/mappings.lua` if needed
3. Add any configuration files to `nvim/lua/configs/` if complex

### Deploying config changes to the local system
This repo is the source of truth; the live config lives at `~/.config/nvim`
(a plain copy, not a symlink). After editing files under `nvim/`, sync the
whole tree across so changes take effect. Use `rsync` with `--delete` so files
removed from the repo are also removed locally:

```sh
rsync -a --delete --exclude='.git' --exclude='lazy-lock.json' nvim/ ~/.config/nvim/
```

Verify the two trees are in sync with
`diff -rq nvim ~/.config/nvim` (ignore `.git` and `lazy-lock.json`).
Then restart Neovim and run `:Lazy sync` / `:Mason` if plugins or tools changed.

### Creating a mock project to test filetype / LSP features
When adding support for a new filetype or language server, create a minimal
throwaway fixture under `/tmp` to test against. For example, a Helm chart at
`/tmp/helm-test-chart` with `Chart.yaml`, `values.yaml`, and
`templates/` (including a `.tpl` helper and templated `*.yaml`) exercises
filetype detection, syntax highlighting, and LSP attachment. Verify with
`:set filetype?`, `:LspInfo`, and `:lua vim.diagnostic.setqflist()`.

#### Python: nx-style uv monorepo fixture
`./scripts/make-python-monorepo-fixture.sh [target-dir]` scaffolds a monorepo at
`/tmp/nx-uv-fixture` that mirrors the work project: `apps/*` and `libs/*` are
each **standalone uv projects**, wired together by `[tool.uv.sources]` path
entries installed as editable. Only apps get `uv sync`'d, matching the usual
state of such a repo; pass `SYNC_LIBS=1` to give each lib its own `.venv` too.

The fixture deliberately covers four navigation directions, because they do not
share a code path:

| | From | Import |
| --- | --- | --- |
| A | `apps/api/src/api/main.py` | `from shared_models.models import Widget` |
| B | `apps/api/src/api/flat_import.py` | `from shared_models import Widget` (re-export) |
| C | `apps/api/tests/test_main.py` | same, from outside `src/` |
| D | `libs/shared-models/.../models.py` | `from shared_utils.helpers import Helper` |

**D is the case that broke.** basedpyright anchors at the *nearest* root marker,
so a file inside a lib gets `root_dir = libs/shared-models` — which has no
`.venv`. Any logic keyed off `<root>/.venv` finds nothing and the import goes
unresolved. This is why `before_init` in `configs/lspconfig.lua` reads
`[tool.uv.sources]` from `pyproject.toml` as well as scanning the venv: the
TOML source works without anything being installed.

Things worth knowing when testing this:
- basedpyright never runs the interpreter, reads `.pth` files, or follows PEP 660
  import hooks. Cross-package imports resolve **only** via `analysis.extraPaths`.
- The interpreter must go to `settings.python.pythonPath`.
  `settings.basedpyright.pythonPath` is silently ignored.
- On macOS `/tmp` is a symlink to `/private/tmp`, so `root_dir` and the paths in
  `direct_url.json` come back as `/private/tmp/...`. Expected, not a bug.
- `uv sync` must be re-run in the app after a lib's *metadata* changes; editing a
  lib's source needs no sync, since `extraPaths` points at the live tree.
- After changing `configs/lspconfig.lua`, rsync to `~/.config/nvim` (above) and
  restart — `:LspRestart` alone will not re-run `before_init` with new code.

To check what the server actually received, rather than guessing from behaviour:

```vim
:lua =vim.lsp.get_clients({ name = "basedpyright" })[1].config.root_dir
:lua =vim.lsp.get_clients({ name = "basedpyright" })[1].settings
```

### Debugging issues
- LSP logs: `:LspLog`
- Check lazy loading: `:Lazy`
- Check installed tools: `:Mason`
