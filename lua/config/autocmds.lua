-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Override LazyVim's window resize behavior to preserve terminal sizing
-- vim.api.nvim_del_augroup_by_name("lazyvim_resize_splits")

-- Create custom resize behavior that preserves terminal proportions
vim.api.nvim_create_augroup("custom_resize_splits", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = "custom_resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    -- Only equalize non-terminal windows
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      -- Check if window is still valid
      if vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.bo[buf].buftype
        if buftype ~= "terminal" then
          vim.cmd("wincmd =")
          break
        end
      end
    end
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- A method to clean up simple glyph errors on save.
local function fix_glyph_issues()
  local save_cursor = vim.fn.getpos(".")
  local save_view = vim.fn.winsaveview()

  -- Safe glyph fixes that won't break code syntax
  vim.cmd([[silent! %s/\s\+$//e]])           -- trailing whitespace
  vim.cmd([[silent! %s/\n\{3,}/\r\r/e]])     -- multiple blank lines
  vim.cmd([[silent! %s/\%u00a0/ /ge]])       -- non-breaking spaces
  vim.cmd([[silent! %s/\%u200b//ge]])        -- zero-width spaces
  vim.cmd([[silent! %s/\%ufeff//ge]])        -- BOM
  vim.cmd([[silent! %s/\%u200c//ge]])        -- zero-width non-joiner
  vim.cmd([[silent! %s/\%u200d//ge]])        -- zero-width joiner
  vim.cmd([[silent! %s/\r\n/\r/e]])          -- CRLF to LF

  -- Tabs to spaces if expandtab is set
  if vim.bo.expandtab then
    local shiftwidth = vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop
    vim.cmd(string.format([[silent! %%s/\t/%s/ge]], string.rep(" ", shiftwidth)))
  end

  -- Ensure single newline at EOF
  vim.cmd([[silent! %s/\n\+\%$//e]])
  if vim.fn.getline('$') ~= '' then
    vim.cmd([[silent! normal! Go]])
  end

  vim.fn.winrestview(save_view)
  vim.fn.setpos(".", save_cursor)
end

-- linewraps
vim.opt_local.wrap = true

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = fix_glyph_issues,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = fix_glyph_issues,
})

