  return {
    "olimorris/codecompanion.nvim",
    opts = {
      show_results_in_chat = true
    },
    dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
    config = function()
      require("codecompanion").setup({
        adapters = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = os.getenv("ANTHROPIC_API_KEY")
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "antrhopic",
          },
          inline = {
            adapter = "anthropic",
          },
        }
      })
    end,
  }
