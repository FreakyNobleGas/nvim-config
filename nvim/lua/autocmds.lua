require "nvchad.autocmds"

-- Custom highlight groups for render-markdown.nvim with Rosepine colors
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Muted dark color palette for markdown headings (Rosé Pine-inspired)
    local bg = {
      purple = "#2d1f4a",
      orange = "#3a2510",
      yellow = "#2f2b10",
      green  = "#1a2f1a",
      blue   = "#1a2a3a",
      red    = "#3a1525",
    }
    local fg = {
      purple = "#c4a7e7",
      orange = "#f6c177",
      yellow = "#e8d48b",
      green  = "#9ccfd8",
      blue   = "#7ec8e3",
      red    = "#eb6f92",
    }

    -- Define heading background highlights with muted dark colors
    vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = bg.purple, fg = fg.purple, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = bg.orange, fg = fg.orange, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = bg.yellow, fg = fg.yellow, bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = bg.green,  fg = fg.green,  bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = bg.blue,   fg = fg.blue,   bold = true })
    vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = bg.red,    fg = fg.red,    bold = true })
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
