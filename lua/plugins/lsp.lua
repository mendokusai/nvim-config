return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local solargraph_path = vim.fn.system("asdf which solargraph | tr -d '\n'")
      if vim.v.shell_error == 0 then
        require("lspconfig").solargraph.setup({
          cmd = { solargraph_path, "stdio" },
        })
      else
        require("lspconfig").solargraph.setup({})
      end
    end,
  },
}
