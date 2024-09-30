local function load(name)
  require("custom." .. name)
end

return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/",
  name = "Custom Plugins",
  config = function()
    load("scratchpads")
    load("yank_test_line")
  end,
}
