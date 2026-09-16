-- ~/.config/nvim/lua/plugins/colorscheme.lua
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          telescope = {
            enabled = true,
          },
          noice = true,
          notify = true,
          mini = true,
        },

        custom_highlights = function()
          return {
            Normal = { bg = "#1e1e2e" },
            NormalNC = { bg = "#1e1e2e" },
            NormalFloat = { bg = "#1e1e2e" },
            FloatBorder = { bg = "#1e1e2e" },
            EndOfBuffer = { bg = "#1e1e2e" },
            VertSplit = { bg = "#1e1e2e" },
            TermNormal = { bg = "#1e1e2e" },
            TermNormalNC = { bg = "#1e1e2e" },
            BufferLinefill = { bg = "#1e1e2e" },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
