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

-- Update the `updated` frontmatter field in zk notes on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = vim.fn.expand "~" .. "/Documents/zk-notes/*.md",
  callback = function()
    local timestamp = os.date "%Y-%m-%d %H:%M"
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
      if line:match "^updated:" then
        lines[i] = "updated: " .. timestamp
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        break
      end
    end
  end,
})
