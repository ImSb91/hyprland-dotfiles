return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.opt.termguicolors = true

    local palette = require("catppuccin.palettes").get_palette("mocha")
    local mocha = palette

    -- catppuccin's groups.integrations.bufferline was removed; colors are applied directly
    local highlights = {
      fill = { bg = mocha.base },
      background = { bg = mocha.base },

      buffer = { fg = mocha.text, bg = mocha.base },
      buffer_visible = { fg = mocha.text, bg = mocha.base },
      buffer_selected = { fg = mocha.text, bg = mocha.base, bold = true },

      separator = { fg = mocha.base, bg = mocha.base },
      separator_visible = { fg = mocha.base, bg = mocha.base },
      separator_selected = { fg = mocha.base, bg = mocha.base },

      close_button = { fg = mocha.overlay0, bg = mocha.base },
      close_button_visible = { fg = mocha.overlay0, bg = mocha.base },
      close_button_selected = { fg = mocha.red, bg = mocha.base },
    }

    require("bufferline").setup({
      highlights = highlights,
      options = {
        mode = "buffers",
        separator_style = "thin",
        diagnostics = "nvim_lsp",
        show_close_icon = true,
        show_buffer_close_icons = true,
        color_icons = true,
        always_show_bufferline = true,
        show_tab_indicators = true,
        enforce_regular_tabs = true,
        max_name_length = 18,
        tab_size = 20,
      },
    })
  end,
}