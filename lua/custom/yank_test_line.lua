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

local function build_test_command(test_name, line_number)
  local test_command = "test " .. double_quote(test_name)

  if line_number then
    test_command = test_command .. ", " .. line_number
  end

  return test_command
end

local function save_to_clipboard_and_notify(test_command)
  vim.fn.setreg("+", test_command)
  noice.notify(test_command, "success")
end

local function not_a_test_file()
  noice.notify("Not a test file!", "warn")
end

local function find_test_line_number()
  local cursor_line = vim.fn.line(".")

  while cursor_line > 0 do
    local line_content = vim.fn.getline(cursor_line)
    if line_content:match("^%s*test%s") then
      return cursor_line
    end

    cursor_line = cursor_line - 1
  end
end

local function yank_test_line()
  local test_name = maybe_test_name()

  if test_name then
    local test_command = build_test_command(test_name)
    save_to_clipboard_and_notify(test_command)
  else
    not_a_test_file()
  end
end

local function yank_test_line_with_number()
  local test_name = maybe_test_name()

  if test_name then
    local line_number = find_test_line_number()

    if line_number then
      local test_command = build_test_command(test_name, line_number)
      save_to_clipboard_and_notify(test_command)
    else
      noice.notify("Unable to find test line number. Move the cursor inside a test and try again.", "warn")
    end
  else
    not_a_test_file()
  end
end

vim.api.nvim_create_user_command("Ytest", yank_test_line, {})
vim.api.nvim_create_user_command("Ytestn", yank_test_line_with_number, {})
