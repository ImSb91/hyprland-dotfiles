-- Match statusline module background and border colors
vim.api.nvim_set_hl(0, "St_mode", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
vim.api.nvim_set_hl(0, "St_modeSep", { fg = "#89b4fa", bg = "#1e1e2e" })

vim.api.nvim_set_hl(0, "St_file_bg", { fg = "#cdd6f4", bg = "#313244" })
vim.api.nvim_set_hl(0, "St_file_sep", { fg = "#313244", bg = "#1e1e2e" })

vim.api.nvim_set_hl(0, "St_cwd_bg", { fg = "#1e1e2e", bg = "#cba6f7" })
vim.api.nvim_set_hl(0, "St_cwd_sep", { fg = "#cba6f7", bg = "#1e1e2e" })

vim.api.nvim_set_hl(0, "St_Pos_bg", { fg = "#1e1e2e", bg = "#a6e3a1" })
vim.api.nvim_set_hl(0, "St_Pos_sep", { fg = "#a6e3a1", bg = "#1e1e2e" })
