-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Tree" })

vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })

-- Force clipboard yank mappings
local function yank_to_clipboard()
  local text = vim.fn.getreg('"')
  vim.fn.setreg('+', text)
  vim.fn.setreg('*', text)
end

vim.keymap.set("n", "yy", function() 
  vim.cmd('normal! yy')
  yank_to_clipboard()
end, { desc = "Yank line to clipboard" })

vim.keymap.set("n", "y$", function()
  vim.cmd('normal! y$')
  yank_to_clipboard()
end, { desc = "Yank to end of line" })

vim.keymap.set("n", "yw", function()
  vim.cmd('normal! yw')
  yank_to_clipboard()
end, { desc = "Yank word" })

vim.keymap.set("n", "yW", function()
  vim.cmd('normal! yW')
  yank_to_clipboard()
end, { desc = "Yank WORD" })

vim.keymap.set("v", "y", function()
  vim.cmd('normal! y')
  yank_to_clipboard()
end, { desc = "Yank selection to clipboard" })


-- Custom keymap for commenting
vim.keymap.set("n", "<leader>c", "<Plug>(comment_toggle_linewise_current)", { noremap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("v", "<leader>c", "<Plug>(comment_toggle_linewise_visual)", { noremap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("n", "<leader>b", "<Plug>(comment_toggle_blockwise_current)", { noremap = true, silent = true, desc = "Toggle block comment" })
vim.keymap.set("v", "<leader>b", "<Plug>(comment_toggle_blockwise_visual)", { noremap = true, silent = true, desc = "Toggle block comment" })