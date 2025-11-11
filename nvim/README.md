# NeoVim Configuration

A from-scratch NeoVim configuration using [mini.deps](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md) as the plugin manager.

## Plugin Management with Minideps

Minideps provides three main functions for managing plugins and configuration:

### `add()` - Declare Plugin Dependencies

Registers a plugin to be available in your configuration. This doesn't load or configure the plugin, it just makes it available.

**When to use:**
- Declaring any plugin that needs to be installed
- Always use before `now()` or `later()` that require the plugin
- For plugins you'll lazy-load or configure later

**Example:**
```lua
add({ source = 'author/plugin-name' })

-- With dependencies
add({
  source = 'author/plugin-name',
  depends = { 'author/dependency' }
})
```

### `now()` - Execute Immediately During Startup

Runs code synchronously during NeoVim initialization. This blocks startup, so use sparingly.

**When to use:**
- Colorschemes (must be loaded before UI renders)
- Critical settings needed before editing
- Essential configurations that other plugins depend on

**When NOT to use:**
- Non-critical plugins or settings
- Anything that can wait until after startup
- Heavy computations or file I/O

**Example:**
```lua
now(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme miniwinter')
end)
```

### `later()` - Defer Execution Until After Startup

Runs code asynchronously after NeoVim has loaded. This improves startup time without blocking the UI.

**When to use:**
- Most plugin configurations
- Keymaps (unless needed immediately)
- UI enhancements and non-critical features
- Anything that doesn't need to be ready instantly

**Example:**
```lua
add({ source = 'author/plugin' })

later(function()
  require('plugin').setup({
    option1 = value,
    option2 = value,
  })

  -- Keymaps go here, after setup
  vim.keymap.set('n', '<leader>x', '<cmd>Command<CR>', { desc = 'Description' })
end)
```

## Common Patterns

### Pattern 1: Simple Plugin with Configuration
```lua
add({ source = 'author/plugin' })

later(function()
  require('plugin').setup({ })
end)
```

### Pattern 2: Plugin with Keymaps
```lua
add({ source = 'author/plugin' })

later(function()
  require('plugin').setup({ })

  vim.keymap.set('n', '<leader>k', '<cmd>PluginCommand<CR>', { desc = 'Description' })
end)
```

### Pattern 3: Critical Startup Plugin
```lua
now(function()
  require('mini.basics').setup({
    mappings = { windows = true }
  })
end)
```

### Pattern 4: Plugin with Dependencies
```lua
add({
  source = 'author/plugin',
  depends = { 'author/dependency1', 'author/dependency2' }
})

later(function()
  require('plugin').setup({ })
end)
```

## Configuration Structure

```
~/.config/nvim/
├── init.lua                          # Entry point, sets up mini.deps
├── lua/
│   └── freakynoblegas/
│       ├── core/
│       │   ├── init.lua              # Core configuration loader
│       │   ├── options.lua           # Vim options
│       │   └── keymaps.lua           # Global keymaps
│       └── plugin/
│           ├── init.lua              # Plugin loader
│           ├── mini.lua              # Mini.nvim modules
│           └── nvim-tree.lua         # Individual plugin configs
```

## Tips

1. **Group plugin configs by functionality** - Keep related plugins in the same file
2. **Put keymaps near their plugin setup** - Easier to understand what each plugin does
3. **Use `later()` by default** - Only use `now()` when absolutely necessary
4. **Add descriptions to keymaps** - The `desc` field helps with discovery and documentation
5. **Start minimal, add as needed** - Easier to understand what each piece does

## Useful Resources

- [mini.deps documentation](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-deps.md)
- [mini.nvim modules](https://github.com/echasnovski/mini.nvim)
