-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.showmatch = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.foldmethod = "manual"
vim.opt.fixendofline = false

-- Enable system clipboard
vim.o.clipboard = "unnamed,unnamedplus"

-- Explicitly set clipboard provider for macOS
vim.g.clipboard = {
  name = 'macOS-clipboard',
  copy = {
    ['+'] = 'pbcopy',
    ['*'] = 'pbcopy',
  },
  paste = {
    ['+'] = 'pbpaste',
    ['*'] = 'pbpaste',
  },
  cache_enabled = 0,
}

-- Set reasonable timeout and window constraints
vim.opt.timeoutlen = 300
vim.opt.winminheight = 1
vim.opt.winminwidth = 10

-- Disable automatic window equalization to prevent terminal resizing issues
vim.opt.equalalways = false

-- Additional resize protection settings
vim.opt.winwidth = 10
vim.opt.winheight = 1
vim.opt.cmdheight = 1

-- Prevent vim from trying to resize windows too aggressively

vim.filetype.add({
  extension = {
    heex = "heex",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd("WinNew", {
  pattern = "*",
  callback = function()
    vim.opt.splitright = true
    vim.opt.splitbelow = true
  end,
})