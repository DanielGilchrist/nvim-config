local function disable_plugin(source)
  return { source, enabled = false }
end

return {
  disable_plugin("mfussenegger/nvim-lint"),
  disable_plugin("stevearc/conform.nvim"),
  disable_plugin("rafamadriz/friendly-snippets"),
  disable_plugin("ibhagwan/fzf-lua"),
}
