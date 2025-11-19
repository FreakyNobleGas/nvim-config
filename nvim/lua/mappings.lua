require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- General keymaps
map("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all (discard changes)" })

-- Fuzzy finding
map("n", "<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })

-- LSP diagnostics
map("n", "gk", vim.diagnostic.open_float, { desc = "Show diagnostic popup" })

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Window management
map("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>wh", "<cmd>split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>wd", "<cmd>close<CR>", { desc = "Delete/close window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Make windows equal size" })
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Split window horizontally" })

-- ZK Note-taking keymaps
map("n", "<leader>zn", function()
  vim.ui.input({ prompt = "Note title: " }, function(title)
    if title then
      require("zk.commands").get "ZkNew" { title = title }
    end
  end)
end, { desc = "ZK new note" })

map("n", "<leader>zl", "<cmd>ZkNotes { sort = { 'modified' } }<cr>", { desc = "ZK list notes" })
map("n", "<leader>zf", function()
  vim.ui.input({ prompt = "Search: " }, function(search)
    if search then
      require("zk.commands").get "ZkNotes" { match = { search } }
    end
  end)
end, { desc = "ZK find notes" })
map("n", "<leader>zt", "<cmd>ZkTags<cr>", { desc = "ZK tags" })

-- Yanky keymaps
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map("n", "<c-n>", "<Plug>(YankyCycleForward)")
map("n", "<c-p>", "<Plug>(YankyCycleBackward)")

-- CodeCompanion AI Assistant
map({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
map({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanion Chat Toggle" })
map("n", "<leader>cC", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion Chat New" })
map("v", "<leader>cA", "<cmd>CodeCompanionChat Add<cr>", { desc = "CodeCompanion Add to Chat" })
map({ "n", "v" }, "<leader>ci", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion Inline" })

-- CodeCompanion Context Sharing
-- These keymaps open chat and add the current buffer/file context
-- Note: Slash commands work best when typed manually in chat for interactive selection

-- Add current buffer to new chat
map("n", "<leader>cb", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    vim.notify("Current buffer has no name", vim.log.levels.WARN)
    return
  end
  vim.cmd("CodeCompanionChat")
  vim.defer_fn(function()
    local chat_bufnr = vim.api.nvim_get_current_buf()
    -- Get the buffer content
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines, "\n")
    -- Insert the buffer reference into chat
    local prompt = string.format("Here's the content from %s:\n\n```\n%s\n```\n\n", vim.fn.fnamemodify(bufname, ":~:."), content)
    vim.api.nvim_buf_set_lines(chat_bufnr, -1, -1, false, vim.split(prompt, "\n"))
  end, 200)
end, { desc = "CodeCompanion: Add current buffer" })

-- Add visual selection to chat
map("v", "<leader>cb", function()
  vim.cmd("'<,'>CodeCompanionChat Add")
end, { desc = "CodeCompanion: Add selection to chat" })

-- Quick reference keymaps that just show helpful notifications
map("n", "<leader>cf", function()
  vim.notify(
    "Open chat with <leader>cc, then type:\n/file - to add files\n/buffer - to add buffers\n/symbols - for file structure",
    vim.log.levels.INFO,
    { title = "CodeCompanion Context" }
  )
end, { desc = "CodeCompanion: Context help" })

-- Show all context options
map("n", "<leader>cx", function()
  local msg = [[
CodeCompanion Context Options:

In Chat Buffer, type:
  /buffer   - Add open buffers
  /file     - Add project files
  /symbols  - Add file structure (saves tokens)
  /terminal - Add terminal output
  /workspace- Add workspace context
  /memory   - Manage memory

Variables (in your message):
  #{buffer}   - Current buffer
  #{buffer:filename} - Specific file
  #{lsp}      - LSP diagnostics
  #{viewport} - Current view

Tools (automatically enabled):
  @{files} - File operations
  @read_file, @grep_search, etc.
  ]]
  vim.notify(msg, vim.log.levels.INFO, { title = "CodeCompanion Help" })
end, { desc = "CodeCompanion: Show all context options" })

-- Buffer management keymaps (LazyVim-style)
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })

map("n", "<leader>bd", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "Delete buffer" })

map("n", "<leader>bD", "<cmd>bd<CR>", { desc = "Delete buffer and window" })

map("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, { desc = "Delete other buffers" })

map("n", "<leader>bb", "<cmd>e #<CR>", { desc = "Switch to other buffer" })

map("n", "[b", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })

map("n", "]b", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })

map("n", "<S-h>", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })

map("n", "<S-l>", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })
