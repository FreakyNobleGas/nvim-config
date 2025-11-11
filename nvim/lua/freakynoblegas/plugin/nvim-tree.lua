local add, later = MiniDeps.add, MiniDeps.later

-- Declare nvim-tree plugin dependency
add({ source = 'nvim-tree/nvim-tree.lua' })

-- Configure nvim-tree after startup (non-blocking)
later(function()
  require('nvim-tree').setup({
    -- Add your custom configuration here if needed
    -- view = {
    --   width = 30,
    -- },
    renderer = {
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
  })

  -- Keymaps for nvim-tree
  vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
end)
