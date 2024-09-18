vim.g.material_style = "deep ocean"

return {
  -- { "scottmckendry/cyberdream.nvim", name = "cyberdream" },
  {
    "marko-cerovac/material.nvim",
    name = "material",
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "material",
    },
  },
}
