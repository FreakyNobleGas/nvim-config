
local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add

-- Mini Hue
-- https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hues.md
now(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme miniwinter')
end)

-- Mini Basics
-- https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-basics.md
now(function()
  require('mini.basics').setup({
    mappings = {
	-- Window navigation with <C-hjkl>, resize with <C-arrow>
	windows = true,
    	-- Move cursor in Insert, Command, and Terminal mode with <M-hjkl> (M is option key)
    	move_with_alt = true
    },
  })
end)

-- Mini Bracketed
-- https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-bracketed.md
now(function()
  require('mini.bracketed').setup()
end)

-- Mini Icons
-- https://github.com/nvim-mini/mini.icons
now(function()
  require('mini.icons').setup()
end)

-- Mini Clue
-- https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-clue.md
-- now(function()
--   local miniclue = require('mini.clue')
--   miniclue.setup({
-- 	  triggers = {
-- 	    -- Leader triggers
-- 	    { mode = 'n', keys = '<Leader>' },
-- 	    { mode = 'x', keys = '<Leader>' },

-- 	    -- Built-in completion
-- 	    { mode = 'i', keys = '<C-x>' },

-- 	    -- `g` key
-- 	    { mode = 'n', keys = 'g' },
-- 	    { mode = 'x', keys = 'g' },

-- 	    -- Marks
-- 	    { mode = 'n', keys = "'" },
-- 	    { mode = 'n', keys = '`' },
-- 	    { mode = 'x', keys = "'" },
-- 	    { mode = 'x', keys = '`' },

-- 	    -- Registers
-- 	    { mode = 'n', keys = '"' },
-- 	    { mode = 'x', keys = '"' },
-- 	    { mode = 'i', keys = '<C-r>' },
-- 	    { mode = 'c', keys = '<C-r>' },

-- 	    -- Window commands
-- 	    { mode = 'n', keys = '<C-w>' },

-- 	    -- `z` key
-- 	    { mode = 'n', keys = 'z' },
-- 	    { mode = 'x', keys = 'z' },
-- 	  },

-- 	  clues = {
-- 	    -- Enhance this by adding descriptions for <Leader> mapping groups
-- 	    miniclue.gen_clues.builtin_completion(),
-- 	    miniclue.gen_clues.g(),
-- 	    miniclue.gen_clues.marks(),
-- 	    miniclue.gen_clues.registers(),
-- 	    miniclue.gen_clues.windows(),
-- 	    miniclue.gen_clues.z(),
-- 	  },
--   })
-- end)

add({ source = 'folke/which-key.nvim' })

later(function()
  require('which-key').setup({
    preset = "helix",
  })
end)