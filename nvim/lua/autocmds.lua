require "nvchad.autocmds"

-- Custom highlight groups for render-markdown.nvim with Rosepine colors
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Soft pastel color palette for markdown headings
    local colors = {
      red = "#ffc9d9",
      orange = "#ffe4c4",
      yellow = "#fff4c4",
      green = "#d4f5d4",
      blue = "#c4e4f5",
      purple = "#e5d4f5",
      base = "#2a273f",
    }

    -- Define heading background highlights with soft pastel colors
    vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = colors.purple, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = colors.orange, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = colors.yellow, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = colors.green, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = colors.blue, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = colors.red, fg = colors.base, bold = true })
  end,
})

-- Trigger highlight setup for current colorscheme
vim.schedule(function()
  vim.cmd "doautocmd ColorScheme"
end)
