local function disable_format(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      crystalline = function(_, opts)
        opts.on_attach = function(client)
          disable_format(client)
        end
      end,
    },
  },
}
