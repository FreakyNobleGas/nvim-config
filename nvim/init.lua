-- Global settings

-- disable netrw. This is the default Neovim file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install Mini Plugin
-- https://github.com/nvim-mini/mini.nvim
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Setup Mini Deps Plugin Manager
-- https://github.com/nvim-mini/mini.deps
require('mini.deps').setup({ path = { package = path_package } })



-- Define helpers
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local username = vim.fn.getenv('USER') or vim.fn.getenv('USERNAME')
local cmd = function(cmd) return function() vim.cmd(cmd) end end
local load = function(spec, opts)
  return function()
    opts = opts or {}
    local slash = string.find(spec, "/[^/]*$") or 0
    local name = opts.init or string.sub(spec, slash + 1)
    if slash ~= 0 then
      add(vim.tbl_deep_extend("force", { source = spec }, opts.add or {}))
    end
    require(name)
    if opts.setup then require(name).setup(opts.setup) end
  end
end

require(username .. '.core')
require(username .. '.plugin')

