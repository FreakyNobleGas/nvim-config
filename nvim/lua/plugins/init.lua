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

  -- Telescope fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      pickers = {
        find_files = {
          hidden = true,
          -- Search hidden files including .projen/tasks.json
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--glob", "!.git/*" }
          end,
        },
      },
    },
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

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      file_types = { "markdown", "codecompanion" },
      heading = {
        enabled = true,
        sign = true,
        position = "overlay",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "full",
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_virtual = false,
        -- above = "▄",
        -- below = "▀",
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "@markup.heading.1.markdown",
          "@markup.heading.2.markdown",
          "@markup.heading.3.markdown",
          "@markup.heading.4.markdown",
          "@markup.heading.5.markdown",
          "@markup.heading.6.markdown",
        },
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        position = "left",
        width = "full",
        left_pad = 2,
        right_pad = 2,
        border = "thin",
        above = "▄",
        below = "▀",
        highlight = "RenderMarkdownCode",
      },
      dash = {
        enabled = true,
        icon = "─",
        width = "full",
        highlight = "RenderMarkdownDash",
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
        left_pad = 0,
        right_pad = 1,
        highlight = "RenderMarkdownBullet",
      },
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
        },
        checked = {
          icon = "󰱒 ",
          highlight = "RenderMarkdownChecked",
        },
      },
      quote = {
        enabled = true,
        icon = "▋",
        repeat_linebreak = false,
      },
      pipe_table = {
        enabled = true,
        preset = "round",
        cell = "padded",
        padding = 0,
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
      },
    },
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
          adapter = {
            name = "copilot",
            model = os.getenv("CODECOMPANION_MODEL") or "claude-sonnet-4.5",
          },
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
          adapter = {
            name = "copilot",
            model = os.getenv("CODECOMPANION_MODEL") or "claude-sonnet-4.5",
          },
        },
        cmd = {
          adapter = {
            name = "copilot",
            model = os.getenv("CODECOMPANION_MODEL") or "claude-sonnet-4.5",
          },
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
