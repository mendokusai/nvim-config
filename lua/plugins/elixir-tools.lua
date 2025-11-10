return {
  "elixir-tools/elixir-tools.nvim",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local elixir = require("elixir")
    local elixirls = require("elixir.elixirls")

    -- Setup Lexical LSP
    -- require('lspconfig').lexical.setup {
    --   cmd = { vim.fn.expand("~/.local/bin/expert/expert") },
    --   root_dir = function(fname)
    --     return require('lspconfig').util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
    --   end,
    --   filetypes = { "elixir", "eelixir", "heex" },
    --   settings = {}
    -- }

    elixir.setup {
      nextls = {enable = false},
      elixirls = {
        enable = true,
        settings = elixirls.settings {
          dialyzerEnabled = false,
          enableTestLenses = false,
        },
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        end,
      },
      projectionist = {
        enable = true
      }
    }
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
}
