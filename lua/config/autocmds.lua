-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Override LazyVim's window resize behavior to preserve terminal sizing
vim.api.nvim_del_augroup_by_name("lazyvim_resize_splits")

-- Create custom resize behavior that preserves terminal proportions
vim.api.nvim_create_augroup("custom_resize_splits", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = "custom_resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    -- Only equalize non-terminal windows
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
      if buftype ~= "terminal" then
        vim.cmd("wincmd =")
        break
      end
    end
    vim.cmd("tabnext " .. current_tab)
  end,
})
