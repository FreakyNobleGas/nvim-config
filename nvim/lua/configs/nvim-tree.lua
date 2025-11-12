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
}

return options
