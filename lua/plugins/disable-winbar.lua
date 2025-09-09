return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        globalstatus = true,
        disabled_filetypes = { statusline = { "NvimTree" } },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
        -- Prevent bufferline from triggering window redraws on resize
        always_show_bufferline = false,
        max_name_length = 30,
        tab_size = 21,
        diagnostics = false, -- Disable to reduce redraw events
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,
        separator_style = "thick",
        enforce_regular_tabs = false,
        sort_by = "insert_at_end",
      },
    },
  },
}

