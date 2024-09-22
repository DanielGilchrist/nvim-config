vim.g.material_style = "deep ocean"

return {
  {
    "scottmckendry/cyberdream.nvim",
    name = "cyberdream",
  },
  {
    "marko-cerovac/material.nvim",
    name = "material",
  },
  {
    "Shatur/neovim-ayu",
    name = "ayu",
    opts = {
      mirage = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu",
    },
  },
}
