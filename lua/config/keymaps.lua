-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

local gitlinker = require("gitlinker")
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
end, { desc = "View installed colour themes" })

map("n", "<leader>gy", function()
  local url = gitlinker.get_buf_range_url("n")
  vim.fn.setreg("+", url)
end, { desc = "Copy remote link to clipboard", noremap = true })

map("v", "<leader>gy", function()
  local url = gitlinker.get_buf_range_url("v")
  vim.fn.setreg("+", url)
end, { desc = "Copy remote link to clipboard", noremap = true })
