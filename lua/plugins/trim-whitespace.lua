return {
  {
    "LazyVim/LazyVim",
    opts = {
      autocmds = {
        {
          event = "BufWritePre",
          pattern = "*",
          callback = function()
            vim.cmd([[%s/\s\+$//e]])
          end,
        },
      },
    },
  },
}
