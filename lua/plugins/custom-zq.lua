return {
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "ZQ",
        function()
          local api = vim.api

          -- Get a list of "normal" windows (listed buffers, not NvimTree or other special plugins)
          local function get_normal_windows()
            local normal_wins = {}
            for _, win in ipairs(api.nvim_list_wins()) do
              local buf = api.nvim_win_get_buf(win)
              if vim.bo[buf].buflisted and vim.bo[buf].filetype ~= "NvimTree" then
                table.insert(normal_wins, win)
              end
            end
            return normal_wins
          end

          local normal_windows = get_normal_windows()
          local current_win = api.nvim_get_current_win()
          local current_buf = api.nvim_win_get_buf(current_win)
          local current_ft = vim.bo[current_buf].filetype

          if current_ft == "NvimTree" then
            -- Pressed ZQ in NvimTree window
            vim.cmd("NvimTreeClose")
            -- If there are no other normal windows, quit vim
            if #normal_windows == 0 then
              vim.cmd("qa!")
            end
          else
            -- Pressed ZQ in a normal window
            if #normal_windows <= 1 then
              -- This is the last normal window, so quit vim
              vim.cmd("qa!")
            else
              -- There are other normal windows, so just close the current buffer
              vim.cmd("bdelete!")
            end
          end
        end,
        desc = "Smart quit (close buffer or exit if last)",
        mode = "n",
      },
    },
  },
}
