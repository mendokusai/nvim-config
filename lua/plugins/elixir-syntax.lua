return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "elixir", "heex", "eex" })
      end
    end,
  },
  {
    "elixir-editors/vim-elixir",
    ft = { "elixir", "eelixir", "heex", "surface" },
    config = function()
      -- Ensure syntax highlighting is enabled
      vim.cmd("syntax enable")
      vim.cmd("filetype plugin indent on")
    end,
  },
}