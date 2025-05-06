return {
  {
    "zk-org/zk-nvim",
    config = function()
      require("zk").setup({
        lsp = {
          -- Enable automatic attachment of ZK's LSP - Enable automatic attachment of ZK's LSP - Enable automatic attachment of ZK's LSP - Enable automatic attachment of ZK's LSP - Enable automatic attachment of ZK's LSP - Enable automatic attachment of ZK's LSP
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
        -- Optional: Use Telescope for selecting notes
        picker = "telescope",
      })
    end,
  },
}
