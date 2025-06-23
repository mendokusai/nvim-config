-- ~/.config/nvim/lua/plugins/nvim-tree-keymap.lua
return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
    end,
  },
}

