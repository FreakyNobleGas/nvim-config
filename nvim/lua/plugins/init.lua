return {
  -- Ensure which-key is ready when Neovim starts up
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
    },
  },

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

  -- CodeCompanion AI Assistant
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua", -- For Copilot adapter
      "nvim-telescope/telescope.nvim", -- For pickers
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    opts = {
      -- Set different default adapters per strategy
      strategies = {
        chat = {
          adapter = "copilot", -- Use Copilot for chat by default
          -- Automatically include helpful tools for file operations
          tools = {
            opts = {
              default_tools = {
                "files", -- Includes read_file, file_search, grep_search
              },
            },
          },
        },
        inline = {
          adapter = "copilot", -- Use Copilot for inline edits
        },
        cmd = {
          adapter = "copilot", -- Use Copilot for quick commands
        },
      },

      -- Display options
      display = {
        chat = {
          window = {
            layout = "vertical", -- or "horizontal", "float"
            width = 0.45,
          },
          start_in_insert_mode = true, -- Auto-enter insert mode when opening chat
          show_reasoning = false, -- Disable rendering of thought process for better performance
        },
      },

      -- Memory configuration for persistent context
      memory = {
        groups = {
          -- Default memory group - loads automatically into chats
          default = {
            files = {
              -- Project-level context (create this in your project root)
              { path = "AI_CONTEXT.md", parser = "none" },
              -- User-level preferences (create in ~/.config/nvim/ if desired)
              { path = "~/.config/nvim/AI_CONTEXT.md", parser = "none" },
            },
          },
        },
        opts = {
          chat = {
            default_memory = "default", -- Auto-load default memory group in chats
          },
        },
      },

      -- Optional: Enable debug logging (change to "DEBUG" for troubleshooting)
      log_level = "INFO",
    },
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
