# AI Context for nvim-config

This file provides persistent context to CodeCompanion AI assistant across all chat sessions.

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

### Debugging issues
- LSP logs: `:LspLog`
- Check lazy loading: `:Lazy`
- Check installed tools: `:Mason`
