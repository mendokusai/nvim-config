return {
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "vim", "javascript", "typescript", "ruby", "elixir", "heex", "html", "eex" },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.config").setup(opts)
    end,
  },
  { "dense-analysis/ale" },
  { "andymass/vim-matchup" },
}

