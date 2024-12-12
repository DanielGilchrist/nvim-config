local path = require("../utils/path")

local function load(name)
  require("custom." .. name)
end

return {
  lazy = true,
  event = { "CmdlineEnter" },
  dir = path.absolute_path("/custom"),
  name = "Custom Plugins",
  config = function()
    load("scratchpads")
    load("yank_test_line")
    load("bundle_open")
  end,
}
