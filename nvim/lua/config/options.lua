-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.laststatus = 3 -- global statusline
vim.o.statusline = "%!v:lua.require('nvchad_ui.statusline').run()"

vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = false -- Disable relative line numbers

vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Next Buffer" })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true, desc = "Previous Buffer" })

-- Keep swap files in /tmp so stale ones can't accumulate in state and
-- trigger "Found a swap file" prompts forever.
vim.opt.directory = "/tmp//"
