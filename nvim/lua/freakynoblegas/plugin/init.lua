local username = vim.fn.getenv('USER') or vim.fn.getenv('USERNAME')

require(username .. '.plugin.mini')
require(username .. '.plugin.nvim-tree')