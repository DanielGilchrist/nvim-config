local function disable_format(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

local function cmd_noop()
  return "echo"
end

local function normalise_command(cmd)
  if type(cmd) == "string" then
    cmd = cmd == "" and cmd_noop() or cmd
    return { cmd }
  elseif type(cmd) == "table" then
    return cmd
  else
    error("cmd must be a string or a table!: " .. vim.inspect(cmd))
  end
end

local function gemfile_command_or_fallback(gem_name, command, fallback)
  command = command == nil and normalise_command(gem_name) or normalise_command(command)
  fallback = fallback == nil and command or normalise_command(fallback)

  local gemfile_lock = vim.fn.findfile('Gemfile.lock', '.;')

  if gemfile_lock ~= "" then
    local is_installed = vim.fn.systemlist("grep '" .. gem_name .. "' " .. gemfile_lock)

    if not vim.tbl_isempty(is_installed) then
      return vim.list_extend({ "bundle", "exec" }, command)
    end
  end

  return fallback
end

local function asdf_shim(command)
  vim.fn.expand("~/.asdf/shims/" .. command)
end

return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    local lspconfig = require("lspconfig")

    opts.inlay_hints = {
      enabled = false,
    }

    opts.setup = {
      -- TODO: Can be re-enabled if the following issue is ever resolved: https://github.com/elbywan/crystalline/issues/41
      crystalline = function(_, cr_opts)
        cr_opts.on_attach = function(client)
          disable_format(client)
        end
      end,
    }

    opts.servers = {
      crystalline = {
        mason = false,
        cmd = { "/usr/local/bin/crystalline" },
        root_dir = lspconfig.util.root_pattern("shard.yml", ".git", ".")
      },
      flow = {},
      rubocop = {
        mason = false,
        cmd = gemfile_command_or_fallback("rubocop", { "rubocop", "--lsp" }, ""),
        root_dir = lspconfig.util.root_pattern("Gemfile", ".git", ".")
      },
      ruby_lsp = {
        mason = false,
        cmd = gemfile_command_or_fallback("ruby-lsp", nil, asdf_shim("ruby-lsp"))
      },
      sorbet = {
        mason = false,
        cmd = gemfile_command_or_fallback("sorbet", { "srb", "tc", "--lsp" }, "")
      },
      yamlls = {
        settings = {
          yaml = {
            format = {
              enable = false,
            }
          }
        }
      },
      zls = {
        mason = false,
      }
    }
  end,
}
