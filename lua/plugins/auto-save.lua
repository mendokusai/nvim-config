return {
  "Pocco81/auto-save.nvim",
  event = { "InsertLeave", "TextChanged" },
  config = function()
    require("auto-save").setup({
      enabled = true,
      execution_message = {
        message = function()
          return "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S")
        end,
        dim = 0.18,
        cleaning_interval = 1250,
      },
      debounce_delay = 135,
      condition = function(buf)
        local fn = vim.fn
        return fn.getbufvar(buf, "&modifiable") == 1 and fn.getbufvar(buf, "&buftype") == ""
      end,
    })
  end,
}
