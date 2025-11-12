return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- nvim-tree file explorer
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      return require "configs.nvim-tree"
    end,
  },

  -- Mason auto-installer
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP Servers
        "basedpyright",
        "bash-language-server",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "yaml-language-server",
        "vtsls",
        "svelte-language-server",
        "docker-langserver",
        "docker-compose-language-service",

        -- Linters
        "ruff",
        "shellcheck",
        "markdownlint-cli2",

        -- Formatters
        "black",
        "ufmt",
        "gofumpt",
        "goimports",
        "shfmt",
        "stylua",
        "prettier",

        -- Tools
        "markdown-toc",
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "configs.lint"
    end,
  },

  -- Treesitter with all parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Defaults
        "vim",
        "lua",
        "vimdoc",

        -- Web
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "svelte",

        -- Backend
        "python",
        "go",
        "gomod",
        "gowork",
        "gosum",

        -- Markup
        "json",
        "yaml",
        "markdown",
        "markdown_inline",

        -- Other
        "bash",
        "dockerfile",
      },
    },
  },

  -- ZK Note-taking
  {
    "zk-org/zk-nvim",
    lazy = false,
    config = function()
      require("zk").setup {
        picker = "telescope",
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
          },
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      }
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
    },
    opts = {},
  },

  -- Yanky for enhanced clipboard
  {
    "gbprod/yanky.nvim",
    event = "BufReadPost",
    opts = {
      highlight = { timer = 150 },
    },
  },

  -- Prisma support
  {
    "prisma/vim-prisma",
    lazy = false,
  },

  -- Svelte support
  {
    "leafOfTree/vim-svelte-plugin",
    ft = { "svelte" },
    init = function()
      vim.g.vim_svelte_plugin_load_full_syntax = 1
      vim.g.vim_svelte_plugin_use_typescript = 1
    end,
  },

  -- SchemaStore for JSON/YAML
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },

  -- Flash - Enhanced navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
}
