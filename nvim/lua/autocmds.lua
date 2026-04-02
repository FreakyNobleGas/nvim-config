require "nvchad.autocmds"

-- Fix nvim-treesitter master branch compatibility with Neovim 0.12.0.
-- In 0.12.0, directive/predicate callbacks receive captures as TSNode[]
-- arrays instead of a single TSNode. Override the three broken directives
-- with versions that unwrap the first element.
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(args)
    if args.data ~= "nvim-treesitter" then
      return
    end

    local query = require "vim.treesitter.query"

    -- Unwrap a 0.12.0 TSNode[] capture (or return a bare TSNode as-is)
    local function get_node(match, id)
      local capture = match[id]
      return type(capture) == "table" and capture[1] or capture
    end

    local non_filetype_aliases = {
      ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript",
    }
    local html_script_types = {
      importmap = "json", module = "javascript",
      ["application/ecmascript"] = "javascript",
      ["text/ecmascript"] = "javascript",
    }
    local function md_lang(alias)
      return vim.filetype.match { filename = "a." .. alias }
        or non_filetype_aliases[alias]
        or alias
    end

    query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
      local node = get_node(match, pred[2])
      if not node then return end
      metadata["injection.language"] = md_lang(vim.treesitter.get_node_text(node, bufnr):lower())
    end, { force = true })

    query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
      local node = get_node(match, pred[2])
      if not node then return end
      local val = vim.treesitter.get_node_text(node, bufnr)
      local configured = html_script_types[val]
      if configured then
        metadata["injection.language"] = configured
      else
        local parts = vim.split(val, "/", {})
        metadata["injection.language"] = parts[#parts]
      end
    end, { force = true })

    query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
      local id = pred[2]
      local node = get_node(match, id)
      if not node then return end
      local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
      if not metadata[id] then metadata[id] = {} end
      metadata[id].text = string.lower(text)
    end, { force = true })
  end,
})

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

-- CodeCompanion thinking indicator via fidget.nvim
vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionRequestStarted",
  callback = function()
    require("fidget").notify("thinking…", vim.log.levels.INFO, {
      key = "codecompanion",
      annote = "CodeCompanion",
    })
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = { "CodeCompanionRequestFinished", "CodeCompanionChatStopped" },
  callback = function()
    require("fidget").notify(nil, nil, { key = "codecompanion" })
  end,
})
