local lspconfig = require("lspconfig")

local function disable_format(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false,
    },
    setup = {
      -- TODO: Can be re-enabled if the following issue is ever resolved: https://github.com/elbywan/crystalline/issues/41
      crystalline = function(_, opts)
        opts.on_attach = function(client)
          disable_format(client)
        end
      end,
    },
    servers = {
      rubocop = {
        cmd = { "bundle", "exec", "rubocop", "--lsp" },
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git", ".")
      },
      ruby_lsp = {},
      sorbet = {
        cmd = { "bundle", "exec", "srb", "tc", "--lsp" }
      }
    }
  },
}
