local username = vim.fn.getenv('USER') or vim.fn.getenv('USERNAME')

require(username .. '.plugin.mini')
require(username .. '.plugin.nvim-tree')
require(username .. '.plugin.treesitter')
require(username .. '.plugin.lsp')