require "nvchad.autocmds"

-- which-key clears its buffer trigger cache on every LspAttach. When it
-- rebuilds, is_safe() returns false for <Space> if a <Nop> keymap is present
-- (node.keymap is truthy), so the trigger never gets re-added. Scheduling a
-- wk_buf.get() call after all LspAttach handlers complete forces a Mode.new →
-- update → attach cycle, which re-adds the <Space> trigger cleanly.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.schedule(function()
      local ok, wk_buf = pcall(require, "which-key.buf")
      if ok and vim.api.nvim_buf_is_valid(args.buf) then
        wk_buf.get({ buf = args.buf })
      end
    end)
  end,
})

vim.filetype.add({
  filename = {
    ["Jenkinsfile"] = "groovy",
  },
  pattern = {
    ["Jenkinsfile%..*"] = "groovy",
  },
})

-- Fix nvim-treesitter master branch compatibility with Neovim 0.12.0.
--
-- In 0.12.0, directive callbacks receive each capture as a TSNode[] array
-- rather than a single TSNode. nvim-treesitter (master) still registers
-- `set-lang-from-info-string!`, `set-lang-from-mimetype!`, and `downcase!` with
-- handlers that treat the capture as a bare node, so markdown code-block/YAML
-- frontmatter injections crash the treesitter highlighter (get_node_text /
-- node:range on a table) -- producing the "Decoration provider" error on open.
--
-- We can't simply re-register corrected versions: master registers with
-- force=true when its query_predicates module first loads (lazily, on the first
-- highlight), which would clobber ours, and the load happens via a *scheduled*
-- event so the very first highlight can beat any autocmd-based override anyway.
--
-- Instead, patch query.add_directive itself at startup (the core module is
-- always available, no plugin needed) to LOCK these three names to our correct
-- handlers. Master's later force=true registration is intercepted and ignored,
-- and our handlers are active before any highlight -- eliminating the race.
do
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

  local fixed = {
    ["set-lang-from-info-string!"] = function(match, _, bufnr, pred, metadata)
      local node = get_node(match, pred[2])
      if not node then return end
      metadata["injection.language"] = md_lang(vim.treesitter.get_node_text(node, bufnr):lower())
    end,
    ["set-lang-from-mimetype!"] = function(match, _, bufnr, pred, metadata)
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
    end,
    ["downcase!"] = function(match, _, bufnr, pred, metadata)
      local id = pred[2]
      local node = get_node(match, id)
      if not node then return end
      local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
      if not metadata[id] then metadata[id] = {} end
      metadata[id].text = string.lower(text)
    end,
  }

  -- Register our corrected handlers now, and reject any later registration of
  -- these names (i.e. master's) so ours stay authoritative regardless of order.
  local orig_add_directive = query.add_directive
  for name, handler in pairs(fixed) do
    orig_add_directive(name, handler, { force = true })
  end
  query.add_directive = function(name, handler, opts, ...)
    if fixed[name] then return end
    return orig_add_directive(name, handler, opts, ...)
  end
end

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
