return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").solargraph.setup({})
    end,
  },
}
