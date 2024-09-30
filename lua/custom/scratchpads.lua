local noice = require("noice")
local scratchpads_dir = vim.fn.expand("~/.local/share/scratchpads/")

local function telescope_search(title, attach_mappings_func)
  local args = {
    prompt_title = title,
    cwd = scratchpads_dir,
    hidden = false,
  }

  if attach_mappings_func then
    args.attach_mappings = attach_mappings_func
  end

  require("telescope.builtin").find_files(args)
end

local function build_new_filename(count, extension)
  return scratchpads_dir .. "scratch" .. count .. extension
end

local function scratchpads_dir_not_created()
  return vim.fn.isdirectory(scratchpads_dir) == 0
end

local function create_scratchpad(extension)
  if scratchpads_dir_not_created() then
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
    { lang = "Bash", ext = ".sh" },
    { lang = "Fish", ext = ".fish" },
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
  if scratchpads_dir_not_created() or #vim.fn.globpath(scratchpads_dir, "*") == 0 then
    noice.notify("No scratchpads have been created. Create one with `:ScratchNew`.", "warn")
  else
    telescope_search("Search Scratchpads")
  end
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

local function remove_scratchpad()
  local actions_state = require("telescope.actions.state")
  local actions = require("telescope.actions")

  local delete_scratchpad = function(prompt_bufnr)
    local selected_entry = actions_state.get_selected_entry()
    actions.close(prompt_bufnr)

    local input_prompt = "Are you sure you want to remove " .. selected_entry.value .. "?"
    vim.ui.input({ prompt = input_prompt }, function(input)
      if input == "y" then
        os.remove(scratchpads_dir .. selected_entry.value)
        noice.notify("Removed " .. selected_entry.value, "success")
      else
        noice.notify("Action to remove " .. selected_entry.value .. " has been cancelled", "warn")
      end
    end)
  end

  telescope_search("Delete Scratchpad", function(_, map)
    map("i", "<CR>", delete_scratchpad)

    return true
  end)
end

vim.api.nvim_create_user_command("ScratchNew", new_scratchpad, {})
vim.api.nvim_create_user_command("ScratchOpen", open_scratchpad, {})
vim.api.nvim_create_user_command("ScratchRename", rename_scratchpad, {})
vim.api.nvim_create_user_command("ScratchRemove", remove_scratchpad, {})
