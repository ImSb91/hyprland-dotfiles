-- ~/.config/nvim/lua/plugins/ui.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
  },
  {
    "akinsho/bufferline.nvim",
    enabled = true,
  },
  {
    "goolord/alpha-nvim",
    enabled = false,
  },

  {
    "kingavatar/nvchad-ui.nvim",
    branch = "v2.0",
    lazy = false,
    config = function()
      require("nvchad_ui").setup({
        lazyVim = true,

        statusline = {
          enabled = true,
          theme = "minimal", -- or "minimal"
          separator_style = "round", -- "round" | "block" | "arrow" | "default"
          lualine = false,
          lsprogress_len = 40,
        },

        tabufline = {
          enabled = false, -- enable tabufline
          type = "tabs", -- or "buffers"
          show_numbers = true, -- show buffer numbers
          lazyload = true,
          overriden_modules = nil,
        },

        nvdash = {
          load_on_startup = false,
          header = {
            "                              ",
            " ███ █     ████▄ ▄▄▄ ▄▄▄ █    ",
            " █ █ █ █ █ ██ ██ █ ▄ █▄▄ ███  ",
            " █ ███   ███  █  ▄▄█ █ █  ",
            "                              ",
          },
          buttons = {
            { "  Find File", "f", "Telescope find_files" },
            { "  Recent Files", "r", "Telescope oldfiles" },
            { "  Find Word", "g", "Telescope live_grep" },
            { "  Bookmarks", "b", "Telescope marks" },
            { "  Themes", "t", "Telescope themes" },
            { "  Mappings", "m", "NvCheatsheet" },
            { "  Config", "c", "e $MYVIMRC" },
            {
              "  Restore Session",
              "s",
              function()
                require("persistence").load()
              end,
            },
            { "󰒲  Lazy", "l", "Lazy" },
            { "  Quit", "q", "qa" },
          },
        },

        cheatsheet = "grid",

        lsp = {
          signature = {
            enabled = false,
            silent = true,
          },
        },

        mappings = require("nvchad_ui.cheatsheet.lazyvim"),
      })

      -- Optional: rename menu
      vim.keymap.set("n", "<leader>cn", require("nvchad_ui.renamer").open, { desc = "nvchad Rename" })
      vim.schedule(function() end)
      vim.schedule(function()
        require("nvchad_ui").reset()
      end)
    end,
  },
}
