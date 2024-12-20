local shit_colourschemes = {
  "^blue$",
  "^darkblue$",
  "^default$",
  "^delek$",
  "^desert$",
  "^elflord$",
  "^evening$",
  "^habamax$",
  "^industry$",
  "^koehler$",
  "^lunaperche$",
  "^morning$",
  "^murphy$",
  "^pablo$",
  "^peachpuff$",
  "^quiet$",
  "^ron$",
  "^shine$",
  "^slate$",
  "^sorbet$",
  "^torte$",
  "^vim$",
  "^wildcharm$",
  "^zaibatsu$",
  "^zellner$",
}

return {
  "ibhagwan/fzf-lua",
  opts = {
    colorschemes = { ignore_patterns = shit_colourschemes },
    grep = {
      rg_glob = true, -- Allows filtering by filetype in grep with `foo -- *.rb` for example
    }
  }
}
