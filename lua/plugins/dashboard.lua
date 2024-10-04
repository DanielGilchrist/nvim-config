local header_logo = "genievim"

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
local function logo_path(logo_name)
  return path.absolute_path("/plugins/logos/") .. logo_name
end

local function load_and_format_logo(logo_name)
  local logo = file.read(logo_path(logo_name .. ".txt")) or default_logo()
  return string.rep("\n", 8) .. logo .. "\n\n"
end

local function register_action(description, icon, key, action)
  local formatted_description = description .. string.rep(" ", 43 - #description)

  return {
    action = action,
    desc = formatted_description,
    icon = icon .. "  ",
    key = key,
    key_format = "  %s",
  }
end

return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function(_, dashboard)
    dashboard.theme = "doom"

    local config = dashboard.config

    local logo = load_and_format_logo(header_logo)
    config.header = vim.split(logo, "\n")

    config.center = {
      register_action("Find File", "", "f", "lua LazyVim.pick()()"),
      register_action("New File", "", "n", "ene | startinsert"),
      register_action("Recent Files", "", "r", 'lua LazyVim.pick("oldfiles")()'),
      register_action("Find Text", "", "g", 'lua LazyVim.pick("live_grep")()'),
      register_action("Config", "", "c", "lua LazyVim.pick.config_files()()"),
      register_action("Restore Session", "", "s", 'lua require("persistence").load()'),
      register_action("Lazy", "󰒲", "l", "Lazy"),
      register_action("Quit", "", "q", function()
        vim.api.nvim_input("<cmd>qa<cr>")
      end),
    }
  end,
}
