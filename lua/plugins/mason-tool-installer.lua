return {
  "WhoIsSethDaniel/mason-tool-installer",
  lazy = true,
  cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
  opts = {
    ensure_installed = {
      "codelldb",
      "crystalline",
      "gopls",
      "lua-language-server",
      "shfmt",
      "stylua",
      "taplo",
      "terraform-ls",
      "tflint",
    },
  },
}
