-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set


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
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

map("n", "<leader>cS", function()
  require("treesj").toggle({ split = { recursive = true } })
end, { desc = "treesj toggle" })
