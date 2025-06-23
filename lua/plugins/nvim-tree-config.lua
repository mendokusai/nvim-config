return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    view = {
      adaptive_size = false,
    },
    actions = {
      open_file = {
        resize_window = false,
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,       -- Show all dotfiles (like `.envrc`)
        hide_by_name = {
          -- remove ".envrc" if it's in this list
        },
      },
    },
  },
}

