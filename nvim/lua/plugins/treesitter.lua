return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- load at startup so Neorg finds the norg parsers on the runtime path
    opts = function(_, opts)
      -- Neorg: make sure its parsers are ensured at startup (rocks provide them)
      vim.list_extend(opts.ensure_installed, { "norg", "norg_meta" })
    end,
  },
}