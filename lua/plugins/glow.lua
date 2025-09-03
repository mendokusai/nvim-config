return {
   {
      "ellisonleao/glow.nvim",
      config = function()
        require("glow").setup({
          style = "dark",
          width = 120,
          height_ratio = 0.9,
          width_ratio = 0.9,
        })
      end
   }
}

