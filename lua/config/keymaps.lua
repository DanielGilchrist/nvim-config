-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local telescope = require("telescope.builtin")

map("n", "<C-p>", telescope.find_files, {})
map("n", "<leader>fg", telescope.live_grep, {})
map("n", "<leader>fb", telescope.buffers, {})
map("n", "<leader>fh", telescope.help_tags, {})

map("n", "<leader>uC", function()
  vim.cmd("doautocmd User LazyColorscheme")
  telescope.colorscheme({ enable_preview = true })
end, {})
