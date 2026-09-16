-- ~/.config/nvim/lua/plugins/lspconfig.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
-- TS now served by vtsls (LazyVim typescript extra); legacy tsserver override removed.

      -- HTML / CSS / JSON already installed in mason; enable them
      -- html-lsp crashes (validProperties null) without explicit CSS-lint settings
      opts.servers.html = {
        settings = {
          css = { lint = { validProperties = {}, validPropertiesAtRules = {} }, validate = true },
          scss = { lint = { validProperties = {}, validPropertiesAtRules = {} } },
          less = { lint = { validProperties = {}, validPropertiesAtRules = {} } },
        },
      }
      opts.servers.cssls = {}
      opts.servers.jsonls = {}
      opts.servers.tailwindcss = {
        settings = {
          tailwindCSS = {
            includeLanguages = { css = "css", html = "html", javascriptreact = "html", typescriptreact = "html" },
          },
        },
      }
    end,
  },
}
