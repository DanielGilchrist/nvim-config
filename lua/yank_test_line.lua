local noice = require("noice")

local function double_quote(text)
  return '"' .. text .. '"'
end

local function maybe_test_name()
  local file_path = vim.fn.expand("%:p")
  if file_path:find("^test") ~= nil then
    return
  end

  return file_path:match("test/(.*)_test%.rb")
end

local function yank_test_line()
  local test_name = maybe_test_name()

  if test_name then
    local test_command = "test " .. double_quote(test_name)

    vim.fn.setreg("+", test_command)
    noice.notify(test_command, "success")
  else
    noice.notify("Not a test file", "warn")
  end
end

vim.api.nvim_create_user_command("Ytest", yank_test_line, {})
