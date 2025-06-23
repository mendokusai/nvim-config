return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      ruby = { "rubocop" },
      elixir = { "mix" },
      python = { "black" },
      typescript = { "prettier" },
      javascript = { "prettier" },
      rust = { "rustfmt" },
      php = { "php_cs_fixer" },
    },
  },
}

