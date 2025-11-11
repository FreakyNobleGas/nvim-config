local username = vim.fn.getenv('USER') or vim.fn.getenv('USERNAME')

require(username .. '.core.options')
require(username .. '.core.keymaps')