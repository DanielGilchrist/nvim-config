return {
  "Wansmer/treesj",
  keys = { "<leader>M" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false
    })
  end,
}
