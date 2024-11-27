return {
  "ruifm/gitlinker.nvim",
  keys = { "<leader>gy", mode = { "n", "v" } },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("gitlinker").setup({
      mappings = nil,
    })
  end,
}
