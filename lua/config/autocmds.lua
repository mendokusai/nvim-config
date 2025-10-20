-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Override LazyVim's window resize behavior to prevent resize loops
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_resize_splits")

local resize_group = vim.api.nvim_create_augroup("custom_resize_splits", { clear = true })
local debounce_ms = 120
local min_columns = 80
local min_lines = 24
local equalize_cooldown_ns = 200000000 -- 200ms expressed in nanoseconds
local severity = vim.diagnostic.severity
local show_warnings = true
local error_only_filter = { min = severity.ERROR, max = severity.ERROR }
local default_diagnostic_config = vim.deepcopy(vim.diagnostic.config())
local errors_only_config = nil

local in_equalize = false
local pending_equalize = false
local last_equalize_time = 0

local function has_multiple_normal_windows()
  local count = 0

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)

      if config.relative == "" then
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.bo[buf].buftype

        if buftype ~= "terminal" and buftype ~= "quickfix" then
          count = count + 1
          if count > 1 then
            return true
          end
        end
      end
    end
  end

  return false
end

local function equalize_splits()
  if in_equalize then
    return
  end

  in_equalize = true
  pending_equalize = false

  if not has_multiple_normal_windows() then
    in_equalize = false
    return
  end

  local ok, err = pcall(vim.cmd, "wincmd =")
  last_equalize_time = vim.loop.hrtime()
  in_equalize = false

  if not ok then
    vim.notify(("Equalize splits failed: %s"):format(err), vim.log.levels.WARN)
  end
end

vim.api.nvim_create_autocmd("VimResized", {
  group = resize_group,
  callback = function()
    if vim.o.columns < min_columns or vim.o.lines < min_lines then
      return
    end

    if in_equalize then
      return
    end

    local now = vim.loop.hrtime()
    if now - last_equalize_time < equalize_cooldown_ns then
      return
    end

    if pending_equalize then
      return
    end

    pending_equalize = true
    vim.defer_fn(equalize_splits, debounce_ms)
  end,
})

local function restrict_severity(option)
  if option == nil or option == false then
    return option
  end
  if option == true then
    return { severity = error_only_filter }
  end
  if type(option) == "table" then
    local copy = vim.deepcopy(option)
    copy.severity = error_only_filter
    return copy
  end
  return option
end

local function build_errors_only_config()
  local config = vim.deepcopy(default_diagnostic_config)
  config.virtual_text = restrict_severity(config.virtual_text)
  config.signs = restrict_severity(config.signs)
  config.underline = restrict_severity(config.underline)
  config.float = restrict_severity(config.float)
  return config
end

local function apply_diagnostic_config()
  if show_warnings then
    vim.diagnostic.config(default_diagnostic_config)
  else
    errors_only_config = errors_only_config or build_errors_only_config()
    vim.diagnostic.config(errors_only_config)
  end
end

local function notify_state()
  vim.notify(
    show_warnings and "Diagnostic warnings enabled" or "Diagnostic warnings hidden (errors only)",
    vim.log.levels.INFO,
    { title = "Diagnostics" }
  )
end

local function disable_warnings()
  if not show_warnings then
    return
  end
  default_diagnostic_config = vim.deepcopy(vim.diagnostic.config())
  errors_only_config = build_errors_only_config()
  show_warnings = false
  apply_diagnostic_config()
  notify_state()
end

local function enable_warnings()
  if show_warnings then
    return
  end
  show_warnings = true
  apply_diagnostic_config()
  errors_only_config = nil
  notify_state()
end

vim.api.nvim_create_user_command("DiagnosticsToggle", function()
  if show_warnings then
    disable_warnings()
  else
    enable_warnings()
  end
end, {})

vim.api.nvim_create_user_command("DiagnosticsDisable", disable_warnings, {})
vim.api.nvim_create_user_command("DiagnosticsEnable", enable_warnings, {})

vim.api.nvim_create_user_command("DT", function()
  vim.cmd("DiagnosticsToggle")
end, {})

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
