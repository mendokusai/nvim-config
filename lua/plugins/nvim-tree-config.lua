return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    view = {
      adaptive_size = false,
      width = 30,
      preserve_window_proportions = true,
    },
    actions = {
      open_file = {
        resize_window = false,
        window_picker = {
          enable = false, -- Disable to prevent window resizing
        },
      },
      resize_window = false, -- Prevent any window resizing
    },
    renderer = {
      add_trailing = false,
      group_empty = false,
      highlight_git = false,
      full_name = false,
      highlight_opened_files = "none",
      root_folder_modifier = ":~",
      indent_width = 2,
      indent_markers = {
        enable = false,
        inline_arrows = true,
        icons = {
          corner = "└",
          edge = "│",
          item = "│",
          none = " ",
        },
      },
    },
    filters = {
      dotfiles = false,
    },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
    vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
  end,
}