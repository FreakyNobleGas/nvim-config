# Neovim Configuration

Personal Neovim configuration built on [NvChad](https://nvchad.com/), optimized for full-stack development with Python, Go, TypeScript, and Svelte.

## Table of Contents

- [Quick Start](#quick-start)
- [CodeCompanion AI Assistant](#codecompanion-ai-assistant)
- [Configuration Structure](#configuration-structure)
- [Installed Tools](#installed-tools)
- [Key Mappings](#key-mappings)
- [Vim Motions Cheatsheet](#vim-motions-cheatsheet)
- [Tips & Tricks](#tips--tricks)

## Quick Start

### First Time Setup

1. Clone this repo to `~/.config/nvim`
2. Launch Neovim - plugins will auto-install via Lazy.nvim
3. Run `:MasonInstallAll` to install LSP servers, formatters, and linters
4. Restart Neovim

### Essential Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager |
| `:Mason` | Manage LSP servers, formatters, linters |
| `:LazyFormatInfo` | Show which formatter is active in current buffer |
| `:LspInfo` | Show LSP server status |
| `:help <command>` | View help for any Vim command |

## CodeCompanion AI Assistant

CodeCompanion provides AI-powered coding assistance using GitHub Copilot. It helps with code generation, refactoring, debugging, and answering questions about your codebase.

### Core Keymaps

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>ca` | n, v | Open Actions menu (quick prompts) |
| `<leader>cc` | n, v | Toggle chat buffer |
| `<leader>cC` | n | Create new chat |
| `<leader>cA` | v | Add selection to existing chat |
| `<leader>ci` | n, v | Inline assistant (edit code directly) |

### Context Sharing Keymaps

These keymaps help you quickly share context with the AI:

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>cb` | n | Add current buffer content to new chat |
| `<leader>cb` | v | Add visual selection to chat |
| `<leader>cf` | n | Show context help (quick slash commands reference) |
| `<leader>cx` | n | Show all context options (comprehensive help) |

**Best Practice:** Open chat with `<leader>cc`, then type slash commands interactively for better control. The slash commands open pickers that let you select specific files/buffers.

### Variables (Use in Chat Buffer)

Variables dynamically insert context into your messages:

- `#{buffer}` - Current buffer content
- `#{buffer:filename}` - Specific file by name
- `#{buffer:path/to/file}` - Specific file by path
- `#{lsp}` - LSP diagnostics and errors
- `#{viewport}` - Your current screen view

**Example usage in chat:**
```
Can you help fix the errors in #{buffer:src/main.ts}? Here are the LSP diagnostics: #{lsp}
```

### Slash Commands (Use in Chat Buffer)

Slash commands provide additional functionality within chat:

| Command | Description |
|---------|-------------|
| `/buffer` | Add buffer(s) to chat |
| `/file` | Add file(s) from project |
| `/symbols` | Add file outline (saves tokens) |
| `/workspace` | Add workspace documentation |
| `/terminal` | Add latest terminal output |
| `/help` | Search Vim help docs |
| `/fetch <url>` | Fetch and add web content |
| `/memory` | Manage memory groups |
| `/quickfix` | Share quickfix list |

### Tools (Agent Capabilities)

Tools enable the AI to interact with your codebase autonomously:

- `@{files}` - Bundle of file operation tools
- `@read_file` - Read file contents
- `@file_search` - Search for files
- `@grep_search` - Search file contents
- `@list_code_usages` - Find symbol references (LSP)
- `@get_changed_files` - Show git diffs

**Note:** File operation tools are automatically enabled in all chats.

### AI Context Files

The configuration automatically loads context from these files if they exist:

- `AI_CONTEXT.md` - Project-level context (in project root)
- `~/.config/nvim/AI_CONTEXT.md` - Global preferences

Edit these files to provide persistent context about your coding standards, project architecture, and preferences. The AI will reference them in all chats.

## Configuration Structure

```
nvim/
├── init.lua                      # Entry point
├── lua/
│   ├── autocmds.lua             # Auto commands
│   ├── chadrc.lua               # NvChad configuration
│   ├── mappings.lua             # All keymaps
│   ├── options.lua              # Vim options
│   ├── configs/                 # Plugin configurations
│   │   ├── conform.lua          # Formatter config
│   │   ├── lazy.lua             # Plugin manager setup
│   │   ├── lint.lua             # Linter config
│   │   ├── lspconfig.lua        # LSP server config
│   │   └── nvim-tree.lua        # File explorer config
│   └── plugins/
│       └── init.lua             # Plugin declarations
└── AI_CONTEXT.md                # Persistent AI context
```

### Adding a New Plugin

1. Add plugin spec to `nvim/lua/plugins/init.lua`:
   ```lua
   {
     "author/plugin-name",
     event = "BufReadPost",  -- Lazy load trigger
     opts = {},              -- Plugin options
   }
   ```

2. Add keymaps to `nvim/lua/mappings.lua` if needed

3. Create config file in `nvim/lua/configs/` for complex setup

## Installed Tools

### LSP Servers
- **Python**: basedpyright
- **Go**: gopls
- **TypeScript/JavaScript**: vtsls
- **Svelte**: svelte-language-server
- **Lua**: lua-language-server
- **Bash**: bash-language-server
- **Markdown**: marksman
- **JSON**: json-lsp
- **YAML**: yaml-language-server
- **Docker**: docker-langserver, docker-compose-language-service

### Formatters
- **Python**: black, ufmt
- **Go**: gofumpt, goimports
- **TypeScript/JavaScript/Svelte**: prettier
- **Lua**: stylua
- **Bash**: shfmt
- **Markdown**: markdown-toc

### Linters
- **Python**: ruff
- **Bash**: shellcheck
- **Markdown**: markdownlint-cli2

### Notable Plugins
- **Treesitter** - Syntax highlighting and code understanding
- **Telescope** - Fuzzy finder for files, buffers, etc.
- **nvim-tree** - File explorer
- **which-key** - Keymap helper
- **Flash** - Enhanced navigation
- **Yanky** - Enhanced clipboard with history
- **ZK** - Zettelkasten note-taking
- **CodeCompanion** - AI assistant with Copilot
- **Copilot** - GitHub Copilot integration

## Key Mappings

### General

| Keymap | Mode | Description |
|--------|------|-------------|
| `jk` | i | Exit insert mode |
| `;` | n | Enter command mode |
| `<leader>q` | n | Quit all windows |
| `<leader>Q` | n | Force quit (discard changes) |

### File Navigation

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader><leader>` | n | Find files (Telescope) |
| `<leader>e` | n | Toggle file explorer |
| `<C-h/j/k/l>` | n | Navigate between windows |

### Buffer Management

| Keymap | Mode | Description |
|--------|------|-------------|
| `<S-h>` | n | Previous buffer |
| `<S-l>` | n | Next buffer |
| `[b` | n | Previous buffer |
| `]b` | n | Next buffer |
| `<leader>bn` | n | New buffer |
| `<leader>bd` | n | Delete buffer |
| `<leader>bD` | n | Delete buffer and window |
| `<leader>bo` | n | Delete all other buffers |
| `<leader>bb` | n | Switch to alternate buffer |

### Window Management

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>wv` | n | Split vertically |
| `<leader>wh` | n | Split horizontally |
| `<leader>\|` | n | Split vertically |
| `<leader>-` | n | Split horizontally |
| `<leader>wd` | n | Close window |
| `<leader>w=` | n | Make windows equal size |

### LSP

| Keymap | Mode | Description |
|--------|------|-------------|
| `gd` | n | Go to definition |
| `gr` | n | Find references |
| `gk` | n | Show diagnostic popup |
| `K` | n | Hover documentation |
| `<leader>ca` | n, v | Code actions |
| `<leader>rn` | n | Rename symbol |

### Flash Navigation

| Keymap | Mode | Description |
|--------|------|-------------|
| `s` | n, x, o | Flash jump |
| `S` | n, x, o | Flash Treesitter |
| `r` | o | Remote flash |
| `R` | o, x | Treesitter search |
| `<C-s>` | c | Toggle flash search |

### Yanky (Clipboard)

| Keymap | Mode | Description |
|--------|------|-------------|
| `p` | n, x | Put after (Yanky) |
| `P` | n, x | Put before (Yanky) |
| `<C-n>` | n | Cycle to next yank |
| `<C-p>` | n | Cycle to previous yank |

### ZK Note-Taking

| Keymap | Mode | Description |
|--------|------|-------------|
| `<leader>zn` | n | Create new note |
| `<leader>zl` | n | List notes by modified date |
| `<leader>zf` | n | Find notes |
| `<leader>zt` | n | Browse tags |

**Note**: ZK requires the `zk` CLI tool to be installed. Keymaps are prefixed with `<leader>z`.

## Vim Motions Cheatsheet

### Text Objects

| Command | Description |
|---------|-------------|
| `vi(` or `vi{` | Select inside parentheses/braces |
| `va(` or `va{` | Select around parentheses/braces |
| `yi(` or `yi{` | Yank inside parentheses/braces |
| `ya(` or `ya{` | Yank around parentheses/braces |
| `viW` | Select until whitespace |
| `ciw` | Change inner word |
| `dap` | Delete a paragraph |

### Navigation

| Command | Description |
|---------|-------------|
| `fx` | Jump to next occurrence of 'x' |
| `Fx` | Jump to previous occurrence of 'x' |
| `tx` | Jump to before next 'x' |
| `Tx` | Jump to after previous 'x' |
| `0` | Jump to start of line |
| `^` | Jump to first non-blank character |
| `$` | Jump to end of line |
| `gg` | Jump to start of file |
| `G` | Jump to end of file |
| `%` | Jump to matching bracket |

### Editing

| Command | Description |
|---------|-------------|
| `dd` | Delete line |
| `yy` | Yank (copy) line |
| `cc` | Change line |
| `u` | Undo |
| `<C-r>` | Redo |
| `.` | Repeat last change |
| `:%s/old/new/g` | Replace all 'old' with 'new' in file |
| `:%s/old/new/gc` | Replace with confirmation |

## Tips & Tricks

### Re-source Configuration

After editing a config file:
```vim
:so
```

### Debug LSP Issues

```vim
:LspInfo          " Show active LSP clients
:LspLog           " View LSP logs
:LspRestart       " Restart LSP server
```

### Check Formatter/Linter

```vim
:LazyFormatInfo   " Show active formatter
:ConformInfo      " Detailed formatter info
```

### Plugin Management

```vim
:Lazy             " Open plugin manager
:Lazy sync        " Install + clean + update all
:Lazy profile     " Check startup times
```

### Mason Tool Management

```vim
:Mason            " Open Mason UI
:MasonUpdate      " Update registry
:MasonLog         " View logs
```

### Find Plugin Source Code

Plugins are installed in:
```
~/.local/share/nvim/lazy/
```

Browse plugin code to understand commands and functions.

### Disable a Plugin

In `nvim/lua/plugins/init.lua`:
```lua
{
  "author/plugin-name",
  enabled = false,
}
```

### NvChad vs Lazy.nvim

- **NvChad**: Full Neovim distribution with pre-configured plugins
- **Lazy.nvim**: Just a plugin manager

This config uses NvChad as the base, which includes Lazy.nvim.

### Configuration Files Syntax

**Global config:**
```lua
vim.g.variable_name = true
```

**Options:**
```lua
vim.opt.option_name = value
```

**Keymaps:**
```lua
vim.keymap.set("mode", "keys", "command", { desc = "Description" })
-- mode: "n" (normal), "i" (insert), "v" (visual), "x" (visual block)
```

**LSP/Diagnostics:**
```lua
vim.diagnostic.config({ ... })
vim.lsp.buf.function_name()
```

## Troubleshooting

### Copilot Authentication Issues

If you see "model is not available" errors:
```vim
:Copilot signout
:Copilot signin
```

### Plugin Not Loading

1. Check if lazy-loaded: `:Lazy`
2. Look for errors: `:messages`
3. Check load event in plugin spec

### LSP Not Working

1. Verify LSP installed: `:Mason`
2. Check LSP active: `:LspInfo`
3. View LSP logs: `:LspLog`
4. Restart LSP: `:LspRestart`

### Formatter Not Running

1. Check formatter available: `:Mason`
2. View format settings: `:LazyFormatInfo`
3. Check `conform.lua` configuration

## Learning Resources

- [NvChad Documentation](https://nvchad.com/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Vim Cheatsheet](https://vim.rtorr.com/)
- [CodeCompanion Docs](https://codecompanion.olimorris.dev/)

## License

This configuration is for personal use. Feel free to use it as inspiration for your own setup.
