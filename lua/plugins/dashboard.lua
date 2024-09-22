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

return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function(_, dashboard)
    local logo = load_and_format_logo(header_logo)
    dashboard.config.header = vim.split(logo, "\n")
  end,
}
