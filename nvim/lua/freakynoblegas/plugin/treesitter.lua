local add, later = MiniDeps.add, MiniDeps.later

-- nvim-treesitter - Core syntax highlighting and parsing
-- NOTE: Treesitter should NOT be lazy-loaded according to maintainers
add({
  source = 'nvim-treesitter/nvim-treesitter',
  -- Use master branch for stability
  checkout = 'master',
  hooks = {
    post_checkout = function()
      vim.cmd('TSUpdate')
    end,
  },
})

-- Configure treesitter immediately (not in later())
require('nvim-treesitter.configs').setup({
  -- Install parsers for these languages
  ensure_installed = {
    'lua',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',
    'python',
    'javascript',
    'typescript',
    'tsx',
    'ruby',
    'svelte',
    'dockerfile',
    'json',
    'yaml',
    'html',
    'css',
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    enable = true,

    -- Disable for large files (performance)
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
})

-- nvim-treesitter-textobjects - Syntax-aware text objects and navigation
add({
  source = 'nvim-treesitter/nvim-treesitter-textobjects',
  depends = { 'nvim-treesitter/nvim-treesitter' },
})

-- Configure textobjects
require('nvim-treesitter.configs').setup({
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- Add to jumplist

      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
        [']a'] = '@parameter.inner',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
        [']A'] = '@parameter.inner',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
        ['[a'] = '@parameter.inner',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
        ['[A'] = '@parameter.inner',
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ['<leader>sa'] = '@parameter.inner', -- swap with next parameter
        ['<leader>sf'] = '@function.outer',  -- swap with next function
      },
      swap_previous = {
        ['<leader>sA'] = '@parameter.inner', -- swap with previous parameter
        ['<leader>sF'] = '@function.outer',  -- swap with previous function
      },
    },
  },
})

-- nvim-treesitter-context - Show code context at top of screen
add({
  source = 'nvim-treesitter/nvim-treesitter-context',
  depends = { 'nvim-treesitter/nvim-treesitter' },
})

later(function()
  require('treesitter-context').setup({
    enable = true,
    max_lines = 3,           -- How many lines the window should span
    min_window_height = 20,  -- Minimum editor window height to enable context
    line_numbers = true,
    multiline_threshold = 1, -- Maximum number of lines to show for a single context
    trim_scope = 'outer',    -- Which context lines to discard if max_lines is exceeded
    mode = 'cursor',         -- Line used to calculate context. 'cursor' or 'topline'
    separator = nil,         -- Separator between context and content. nil to disable
  })

  -- Keymap to toggle context
  vim.keymap.set('n', '<leader>tc', '<cmd>TSContextToggle<CR>', { desc = 'Toggle treesitter context' })
end)
