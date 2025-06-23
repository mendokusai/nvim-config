return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
      keyword_length = 2,  -- Wait for 2 characters before triggering
      -- Add a delay in milliseconds (for menu popup)
      throttle_time = 300,
    })
  end,
}

