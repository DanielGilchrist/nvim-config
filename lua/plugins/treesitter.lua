return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "ruby", "rust", "go", "lua", "vim", "vimdoc", "javascript", "html" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = false },
        auto_install = false,
        ignore_install = {},
      })
    end,
  },
}
