local header_logo = "genie_vim"

local file = require("../utils/file")
local path = require("../utils/path")

-- Create logo and save in dir with
-- https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=LAZYVIM
local function logo_path(logo_name)
  return path.absolute_path("/plugins/logos/") .. logo_name
end

local function load_and_format_logo(logo_name)
  local logo = file.read(logo_path(logo_name .. ".txt")) or "NEOVIM"
  local lines = vim.split(logo, "\n")

  for i, line in ipairs(lines) do
    print(vim.inspect(i))
    lines[i] = "      " .. line
  end

  return string.rep("\n", 8) .. table.concat(lines, "\n") .. "\n\n"
end

return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function(_, dashboard)
    local logo = load_and_format_logo(header_logo)
    dashboard.config.header = vim.split(logo, "\n")
  end,
}
