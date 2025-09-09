return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
      keyword_length = 2,  -- Wait for 2 characters before triggering
      -- Add a delay in milliseconds (for menu popup)
      throttle_time = 300,
    })

    -- Disable completion entirely for markdown files
    opts.enabled = function()
      local filetype = vim.bo.filetype
      if filetype == "markdown" then
        return false
      end
      return true
    end

    return opts
  end,
}

