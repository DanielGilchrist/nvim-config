return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<Up>"] = { "fallback" },
      ["<Down>"] = { "fallback" },
      ["<Left>"] = { "fallback" },
      ["<Right>"] = { "fallback" },
    },
    completion = {
      trigger = {
        show_on_insert_on_trigger_character = false,
      }
    }
  }
}
