return {
  -- Progress/notification UI (LSP progress)
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {},
  },

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
    config = function()
      require("nvim-tree").setup(require "configs.nvim-tree")
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
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*", "--glob", "!.github/*" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden", "--glob", "!.git/*", "--glob", "!.github/*" }
          end,
        },
      },
    },
  },

  -- Mason auto-installer
  {
    "mason-org/mason.nvim",
    event = "VimEnter",
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
        "dockerfile-language-server",
        "docker-compose-language-service",
        "helm-ls",
        "groovy-language-server",
        "solargraph",

        -- Groovy / Jenkins
        "npm-groovy-lint",

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
    config = function(_, opts)
      require("mason").setup(vim.tbl_deep_extend("force", require("nvchad.configs.mason"), opts))
      local mr = require "mason-registry"
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
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
        "groovy",
        "ruby",
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

  -- Image rendering (kitty graphics protocol, used by render-markdown)
  {
    "3rd/image.nvim",
    build = false,
    ft = { "markdown" },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown" },
        },
      },
      max_height_window_percentage = 50,
      hijack_file_patterns = { "*.png", "*.jpg", "*.gif", "*.webp", "*.avif" },
    },
  },

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "3rd/image.nvim",
    },
    opts = {
      file_types = { "markdown" },
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
      image = {
        enabled = true,
      },
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

  -- Helm chart support (filetype detection + syntax highlighting)
  {
    "towolf/vim-helm",
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
