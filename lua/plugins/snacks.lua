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

local function tanda_cli_cmd()
  local command = "tanda_cli time_worked week 2>/dev/null"
  local zsh_command = "zsh -ic '" .. command .. "'" -- zsh is a pain in the ass
  return command .. " || " .. zsh_command .. " || " .. "echo \"tanda_cli isn't setup!\""
end

return {
  "folke/snacks.nvim",
  opts = { -- https://github.com/folke/snacks.nvim/tree/main/docs
    dashboard = {
      enabled = true,
      preset = {
        header = load_header(header)
      },
      sections = {
        { section = "header" },
        { section = "keys",  padding = 1 },
        {
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 1,
          limit = 10,
        },
        {
          icon = "⏲",
          title = "Time Worked",
          section = "terminal",
          cmd = tanda_cli_cmd(),
          padding = 1,
          random = os.time(),
        },
        { section = "startup" },
      },
    },
    notifier = {
      date_format = "%I:%M%p",
      style = "fancy",
      timeout = 5000,
      top_down = false,
    },
    terminal = {
      win = {
        position = "float"
      }
    },
  }
}
