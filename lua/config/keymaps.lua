-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Telescope keymaps
map("n", "<C-p>", function()
  require("telescope.builtin").find_files()
end, { desc = "File Picker" })

map("n", "<leader>fg", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { desc = "Search current working directory" })

map("n", "<leader>fc", function()
  require("telescope.builtin").live_grep({ search_dirs = { vim.fn.expand("%:p") } })
end, { desc = "Search current file" })

map("n", "<leader>fb", function()
  require("telescope.builtin").buffers()
end, { desc = "Search buffers" })

map("n", "<leader>fh", function()
  require("telescope.builtin").help_tags()
end, { desc = "Search help" })

map("n", "<leader>uC", function()
  vim.cmd("doautocmd User LazyColorscheme")
  require("telescope.builtin").colorscheme({ enable_preview = true })
end, { desc = "View installed colour themes" })

-- Gitlinker keymaps
map("n", "<leader>gy", function()
  local url = require("gitlinker").get_buf_range_url("n")
  vim.fn.setreg("+", url)
end, { desc = "Copy remote link to clipboard", noremap = true })

map("v", "<leader>gy", function()
  local url = require("gitlinker").get_buf_range_url("v")
  vim.fn.setreg("+", url)
end, { desc = "Copy remote link to clipboard", noremap = true })

-- Diagnostic keymaps
map("n", "<leader>fd", function()
  require("telescope.builtin").diagnostics()
end, { desc = "Find diagnostics" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
