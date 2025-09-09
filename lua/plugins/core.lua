return {
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  { "dense-analysis/ale" },
  { "andymass/vim-matchup" },
}

