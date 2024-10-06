local function colourscheme(source, name, opts)
  opts = opts == nil and {} or opts

  return {
    source,
    name = name,
    opts = opts,
    event = "User LazyColorscheme",
  }
end

return {
  colourscheme("scottmckendry/cyberdream.nvim", "cyberdream"),
  colourscheme("marko-cerovac/material.nvim", "material"),
  colourscheme("Shatur/neovim-ayu", "ayu"),
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu",
    },
  },
}
