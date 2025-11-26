require "nvchad.autocmds"

-- Custom highlight groups for render-markdown.nvim with Rosepine colors
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Rosepine color palette
    local colors = {
      red = "#eb6f92",
      orange = "#f6c177",
      yellow = "#f6c177",
      green = "#ABE9B3",
      blue = "#8bbec7",
      purple = "#c4a7e7",
      base = "#191724",
    }

    -- Define heading background highlights with Rosepine colors
    vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = colors.red, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = colors.orange, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = colors.yellow, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = colors.green, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = colors.blue, fg = colors.base, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = colors.purple, fg = colors.base, bold = true })
  end,
})

-- Trigger highlight setup for current colorscheme
vim.schedule(function()
  vim.cmd("doautocmd ColorScheme")
end)
