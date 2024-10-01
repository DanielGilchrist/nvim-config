local function disable_format(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      -- TODO: Can be re-enabled if the following issue is ever resolved: https://github.com/elbywan/crystalline/issues/41
      crystalline = function(_, opts)
        opts.on_attach = function(client)
          disable_format(client)
        end
      end,
      -- TODO: See if autoformat can be kept while respecting project config
      ruby_lsp = function(_, opts)
        opts.on_attach = function(client)
          disable_format(client)
        end
      end,
    },
  },
}
