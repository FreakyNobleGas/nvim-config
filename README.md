# README

This repository holds my Neovim config. I am currently using the LazyVim distribution as a starting point while I learn more about Neovim.

## Config File Syntax

### Commands

To learn what a command does, you can search for it in the help menu. This only works for official commands such as `inccommand`.

```shell
:h inccommand
```

Re-source a file after editing
`:so`

### Configuration

`.g` represents global config.

```lua
vim.g.have_nerd_font = true
```

`.opt` represents options (for the most part)

```lua
vim.opt.have_nerd_font = true
```

Options for the lsp

```lua
vim.diagnostic.
```

### Keymaps

Parameters for the set method:

1. The mode where the key is available (e.g. "n" is normal mode)
2. The command that needs to be executed (e.g. jj in the code below)
3. The command that's executed (e.g. the escape key in the code below)

```lua
vim.keymap.set("n", "jj", "<Esc>")
```

Use function in keymap

```lua
vim.keymap.set("i", "jk", function()
  print("hello world")
end)
```

## Vim Motion Cheatsheet

### Within a () or {}

NOTE: These commands will also take you to the () or {}. It does not need to be selected.

Select Text
`vi(`
`vi{`

Yank Text
`yi(`
`yi{`

### Around and within a () or {}

Select Text
`va(`
`va{`

Yank Text
`ya(`
`ya{`

### Select text until white space

This is handy for working with lines that end in a semi-colon. You can then paste over it if needed.
`viW`

### Jump to character

Jump to previous x character
`Fx`

Jump to next x character
`fx`

## Plugins

### Copilot

Both `ai.copilot` and `ai.copilot-chat` need to be installed
