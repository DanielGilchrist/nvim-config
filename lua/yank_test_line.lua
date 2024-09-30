local noice = require("noice")

local function yank_test_line()
  local line = vim.fn.search("^# test", "W")

  if line > 0 then
    local test_line = vim.fn.getline(line):gsub("^#%s*", "")

    vim.fn.setreg("+", test_line)
    noice.notify(test_line, "success")
  else
    noice.notify("Unable to find test comment in file", "error")
  end
end

vim.api.nvim_create_user_command("Ytest", yank_test_line, {})
