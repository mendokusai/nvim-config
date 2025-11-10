local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = { "lua", "vim", "javascript", "typescript", "ruby", "elixir", "heex", "html", "eex" },
  sync_install = true,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})
