local header = "neovim"

local file = require("../utils/file")
local path = require("../utils/path")

local function default_logo()
  return [[
      ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
      ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
      ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
      ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
      ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
      ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
  ]]
end

-- Create logo and save in dir with
-- https://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=LAZYVIM
local function logo_path(header_name)
  return path.absolute_path("/plugins/logos/") .. header_name
end

local function load_header(header_name)
  return file.read(logo_path(header_name .. ".txt")) or default_logo()
end

return {
  "folke/snacks.nvim",
  opts = { -- https://github.com/folke/snacks.nvim/tree/main/docs
    dashboard = {
      enabled = true,
      preset = {
        header = load_header(header)
      }
    },
    notifier = {
      top_down = false
    },
    terminal = {
      win = {
        position = "float"
      }
    },
  }
}