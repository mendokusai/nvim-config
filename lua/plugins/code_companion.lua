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

          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = os.getenv("GEMINI_API_KEY")
              },
            })
          end,
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = "cmd.op read op://personal/openai.com'api_key --no-newline",
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
