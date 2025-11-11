-- Sets the global leader key for all mappings using <leader>
vim.g.mapleader = " "

-- Sets the local leader key for mappings using <localleader>
vim.g.maplocalleader = " "

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<cr>', { desc = 'Toggle nvim-tree' })