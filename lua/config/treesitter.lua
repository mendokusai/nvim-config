local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "lua", "vim", "javascript", "typescript", "ruby", "elixir", "heex", "html", "eex" },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})
