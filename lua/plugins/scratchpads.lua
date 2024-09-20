return {
  dir = vim.fn.stdpath("config") .. "/lua",
  name = "scratchpads",
  config = function()
    require("scratchpads")
  end
}
