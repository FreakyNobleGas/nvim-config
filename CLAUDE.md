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

### Debugging issues
- LSP logs: `:LspLog`
- Check lazy loading: `:Lazy`
- Check installed tools: `:Mason`
