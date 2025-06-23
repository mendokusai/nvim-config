return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
    config = function()
      vim.cmd("highlight Visual guibg=#44475a guifg=NONE")
    end,
  },
}
