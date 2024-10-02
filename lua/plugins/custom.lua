local path = require("../utils/path")

local function load(name)
  require("custom." .. name)
end

return {
  dir = path.absolute_path("/custom"),
  name = "Custom Plugins",
  config = function()
    load("scratchpads")
    load("yank_test_line")

    -- TODO: Not sure where a good place for this is yet
    local lspconfig = require("lspconfig")
    lspconfig.flow.setup({})
  end,
}
