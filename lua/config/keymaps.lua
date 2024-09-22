-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local telescope = require("telescope.builtin")

map("n", "<C-p>", telescope.find_files, { desc = "File Picker" })
map("n", "<leader>fg", telescope.live_grep, { desc = "Search current working directory" })
map("n", "<leader>fC", function()
  telescope.live_grep({ search_dirs = { vim.fn.expand("%:p") } })
end, { desc = "Search current file" })
map("n", "<leader>fb", telescope.buffers, { desc = "Search buffers" })
map("n", "<leader>fh", telescope.help_tags, { desc = "Search help" })

map("n", "<leader>uC", function()
  vim.cmd("doautocmd User LazyColorscheme")
  telescope.colorscheme({ enable_preview = true })
end, {})
