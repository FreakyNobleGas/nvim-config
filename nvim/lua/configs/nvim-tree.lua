local options = {
  filters = {
    dotfiles = false,     -- Show files starting with a dot
    git_ignored = false,  -- Show files ignored by git
    custom = {},          -- Remove any custom filters
  },
  git = {
    enable = true,
    ignore = false,       -- Show git-ignored files
  },
  renderer = {
    hidden_display = "all", -- Show all hidden files
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  view = {
    width = 30,
  },
  update_focused_file = {
    enable = true,        -- Highlight current file in tree
    update_root = false,  -- Don't change root when switching files
  },
  actions = {
    open_file = {
      window_picker = {
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", "checkhealth" },
          -- "nofile" is dropped from the defaults so the nvdash dashboard (a
          -- scratch buffer) is replaced by the opened file, not left beside a new split
          buftype = { "terminal", "help" },
        },
      },
    },
  },
}

return options
