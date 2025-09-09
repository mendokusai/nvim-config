-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Override LazyVim's window resize behavior to prevent resize loops
-- Safely delete the group if it exists
local success, _ = pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_resize_splits")
if not success then
  -- Group doesn't exist yet, which is fine
end

-- Create custom resize behavior with debouncing and terminal detection
local resize_timer = nil
local last_resize_time = 0
local resize_count = 0
local max_resize_attempts = 3

vim.api.nvim_create_augroup("custom_resize_splits", { clear = true })
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = "custom_resize_splits",
  callback = function()
    local current_time = vim.loop.hrtime()
    
    -- Reset counter if enough time has passed
    if current_time - last_resize_time > 2000000000 then -- 2 seconds in nanoseconds
      resize_count = 0
    end
    
    -- Prevent resize loops by limiting attempts
    resize_count = resize_count + 1
    if resize_count > max_resize_attempts then
      return
    end
    
    last_resize_time = current_time
    
    -- Check if we're in a very small terminal (likely floating)
    local columns = vim.o.columns
    local lines = vim.o.lines
    if columns < 80 or lines < 24 then
      -- Skip resize operations in very small terminals
      return
    end
    
    if resize_timer then
      vim.fn.timer_stop(resize_timer)
    end
    
    resize_timer = vim.fn.timer_start(250, function() -- Increased debounce to 250ms
      local current_tab = vim.fn.tabpagenr()
      local has_resized = false
      
      -- Only equalize non-terminal, non-floating windows
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) then
          local buf = vim.api.nvim_win_get_buf(win)
          local buftype = vim.bo[buf].buftype
          local config = vim.api.nvim_win_get_config(win)
          
          -- Skip terminals and floating windows
          if buftype ~= "terminal" and config.relative == "" then
            if not has_resized then
              vim.cmd("wincmd =")
              has_resized = true
            end
            break
          end
        end
      end
      
      vim.cmd("tabnext " .. current_tab)
    end)
  end,
})

-- Emergency escape hatch for resize loops
local function create_resize_escape_hatch()
  local rapid_resize_count = 0
  local last_rapid_resize = 0
  
  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("resize_escape_hatch", { clear = true }),
    callback = function()
      local current_time = vim.loop.hrtime()
      
      -- If we get more than 5 resizes in 1 second, disable all resize handling
      if current_time - last_rapid_resize < 1000000000 then -- 1 second
        rapid_resize_count = rapid_resize_count + 1
        if rapid_resize_count > 5 then
          -- Emergency: Disable all autocmds for VimResized
          vim.api.nvim_del_augroup_by_name("custom_resize_splits")
          vim.notify("Resize loop detected! Disabled resize handling. Restart nvim to re-enable.", vim.log.levels.WARN)
          return
        end
      else
        rapid_resize_count = 0
      end
      
      last_rapid_resize = current_time
    end,
  })
end

-- Initialize the escape hatch
create_resize_escape_hatch()

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
  vim.cmd([[silent! %s/\n\+\%\%$///e]])
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.conceallevel = 0
  end,
})