return {
  "zk-org/zk-nvim",
  config = function()
    require("zk").setup({
      -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
      -- or select" (`vim.ui.select`).
      picker = "select",

      lsp = {
        -- `config` is passed to `vim.lsp.start(config)`
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
          -- on_attach = ...
          -- etc, see `:h vim.lsp.start()`
        },

        -- automatically attach buffers in a zk notebook that match the given filetypes
        auto_attach = {
          enabled = true,
        },
      },
      vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = "New ZK note" }),
      vim.keymap.set("n", "<leader>zl", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "List ZK notes" }),
      vim.keymap.set(
        "n",
        "<leader>zf",
        "<Cmd>ZkNotes { search = vim.fn.input('Search: ') }<CR>",
        { desc = "Find ZK notes" }
      ),
      vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "List ZK tags" }),
    })
  end,
}
