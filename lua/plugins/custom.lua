return {
  dir = vim.fn.stdpath("config") .. "/lua/custom",
  name = "Custom Plugins",
  config = function()
    require("scratchpads")
    require("yank_test_line")
  end,
}
