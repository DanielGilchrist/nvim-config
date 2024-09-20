local noice = require("noice")
local scratchpads_dir = vim.fn.expand("~/.local/share/scratchpads/")

local function build_new_filename(count, extension)
  return scratchpads_dir .. "scratch" .. count .. extension
end

local function create_scratchpad(extension)
  if vim.fn.isdirectory(scratchpads_dir) == 0 then
    vim.fn.mkdir(scratchpads_dir, "p")
  end

  local count = 1
  local filename = build_new_filename(count, extension)

  while vim.fn.filereadable(filename) == 1 do
    count = count + 1
    filename = build_new_filename(count, extension)
  end

  vim.cmd("edit " .. filename)
end

local function new_scratchpad()
  vim.ui.select({
    { lang = "Ruby", ext = ".rb" },
    { lang = "Crystal", ext = ".cr" },
    { lang = "JavaScript", ext = ".js" },
    { lang = "SQL", ext = ".sql" },
    { lang = "Text", ext = ".txt" },
  }, {
    prompt = "Select a language",
    format_item = function(item)
      return item.lang
    end,
  }, function(choice)
    if choice then
      create_scratchpad(choice.ext)
    end
  end)
end

local function open_scratchpad()
  local no_scratchpads = false

  if vim.fn.isdirectory(scratchpads_dir) == 0 then
    no_scratchpads = true
  else
    local files = vim.fn.globpath(scratchpads_dir, "*")

    if #files == 0 then
      no_scratchpads = true
    end
  end

  if no_scratchpads then
    noice.notify("No scratchpads have been created. Create one with `:ScratchNew`.", "warn")
    return
  end

  require("telescope.builtin").find_files({
    prompt_title = "Search Scratchpads",
    cwd = vim.fn.expand("~/.local/share/scratchpads/"),
    hidden = false,
  })
end

local function valid_scratch_file(filename)
  return filename ~= "" and vim.fn.filereadable(filename) and filename:find(scratchpads_dir, 1, true)
end

local function rename_scratchpad()
  local old_filename = vim.api.nvim_buf_get_name(0)

  if not valid_scratch_file(old_filename) then
    noice.notify(old_filename .. " is not a scratch file!", "error")
    return
  end

  vim.ui.input({
    prompt = "New name: ",
    default = vim.fn.fnamemodify(old_filename, ":t"),
  }, function(new_name)
    if new_name then
      local new_filename = scratchpads_dir .. new_name

      vim.fn.rename(old_filename, new_filename)
      vim.cmd("bd!")
      vim.cmd("edit " .. new_filename)
      noice.notify("Scratchpad renamed from " .. old_filename .. " to " .. new_filename, "success")
    end
  end)
end

vim.api.nvim_create_user_command("ScratchNew", new_scratchpad, {})
vim.api.nvim_create_user_command("ScratchOpen", open_scratchpad, {})
vim.api.nvim_create_user_command("ScratchRename", rename_scratchpad, {})
