require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

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
