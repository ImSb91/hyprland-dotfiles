return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        filetypes = { "*", "!lazy" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          css = true,
          css_fn = true,
          mode = "background", -- Or "virtualtext" or "foreground"
        },
      })
    end,
  },
}
