-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.lsp.set_log_level("debug")

vim.g.lazyvim_picker = "telescope"

vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

vim.filetype.add({
  extension = {
    rbi = "ruby",
  },
})

vim.opt.relativenumber = true
