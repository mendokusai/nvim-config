-- bootstrap lazy.nvim, LazyVim and your plugins
-- Set <leader> key
vim.g.mapleader = ","

-- Ensure Lazy is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin definitions from lua/plugins/
require("config.lazy")
require("config.options")
require("config.keymaps")
require("lazy").setup("plugins")
