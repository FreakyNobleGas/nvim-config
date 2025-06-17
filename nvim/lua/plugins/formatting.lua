return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      python = { "ufmt", "black" },
      typescript = { "prettier" },
      svelte = { "prettier" },
    },
  },
}
