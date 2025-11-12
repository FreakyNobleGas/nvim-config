require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- General keymaps
map("n", "<leader>q", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all (discard changes)" })

-- ZK Note-taking keymaps
map("n", "<leader>zn", function()
  vim.ui.input({ prompt = "Note title: " }, function(title)
    if title then
      require("zk.commands").get("ZkNew")({ title = title })
    end
  end)
end, { desc = "ZK new note" })

map("n", "<leader>zl", "<cmd>ZkNotes { sort = { 'modified' } }<cr>", { desc = "ZK list notes" })
map("n", "<leader>zf", function()
  vim.ui.input({ prompt = "Search: " }, function(search)
    if search then
      require("zk.commands").get("ZkNotes")({ match = { search } })
    end
  end)
end, { desc = "ZK find notes" })
map("n", "<leader>zt", "<cmd>ZkTags<cr>", { desc = "ZK tags" })

-- Yanky keymaps
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map("n", "<c-n>", "<Plug>(YankyCycleForward)")
map("n", "<c-p>", "<Plug>(YankyCycleBackward)")

-- Copilot Chat
map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat" })

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
