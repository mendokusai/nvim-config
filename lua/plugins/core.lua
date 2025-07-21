return {
  { "nvim-lua/plenary.nvim", lazy = true },
  { 
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end
  },
  { "plasticboy/vim-markdown" },
  { "dense-analysis/ale" },
  { "andymass/vim-matchup" },
}
