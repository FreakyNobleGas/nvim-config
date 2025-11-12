-- Sets the global leader key for all mappings using <leader>
vim.g.mapleader = " "

-- Sets the local leader key for mappings using <localleader>
vim.g.maplocalleader = " "

-- Global keymaps
vim.keymap.set('n', '<leader>q', '<cmd>quit<CR>', { desc = 'Quit' })