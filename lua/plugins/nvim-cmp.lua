return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.enabled = opts.enabled or function()
        return vim.bo.filetype ~= "markdown"
      end

      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.auto_show = false
      opts.completion.menu.auto_show_delay_ms = nil

      opts.completion.documentation = opts.completion.documentation or {}
      opts.completion.documentation.auto_show = false

      opts.completion.ghost_text = opts.completion.ghost_text or {}
      opts.completion.ghost_text.enabled = false

      opts.keymap = opts.keymap or {}
      opts.keymap["<C-Space>"] = opts.keymap["<C-Space>"] or { "show", "show_documentation", "hide_documentation" }
      opts.keymap["<Esc>"] = opts.keymap["<Esc>"] or { "hide", "fallback" }

      return opts
    end,
  },
}
