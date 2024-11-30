local notify = require("../utils/notify")
local scratchpads_dir = vim.fn.expand("~/.local/share/scratchpads/")

local function telescope_search(title, opts)
  opts = opts == nil and {} or opts

  local args = {
    prompt_title = title,
    cwd = scratchpads_dir,
    hidden = false,
  }

  if opts.attach_mappings then
    args.attach_mappings = opts.attach_mappings
  end

  if opts.multi_select then
    args.multi_icon = "▸"
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
    { lang = "Ruby",       ext = ".rb" },
    { lang = "Crystal",    ext = ".cr" },
    { lang = "JavaScript", ext = ".js" },
    { lang = "SQL",        ext = ".sql" },
    { lang = "Text",       ext = ".txt" },
    { lang = "Bash",       ext = ".sh" },
    { lang = "Fish",       ext = ".fish" },
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
    notify.warn("No scratchpads have been created. Create one with `:ScratchNew`.")
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
    notify.error(old_filename .. " is not a scratch file!")
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
      notify.info("Scratchpad renamed from " .. old_filename .. " to " .. new_filename)
    end
  end)
end

local function remove_scratchpad()
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")

  local delete_scratchpads = function(prompt_bufnr)
    local picker = actions_state.get_current_picker(prompt_bufnr)
    local selected_entries = picker:get_multi_selection()
    actions.close(prompt_bufnr)

    if vim.tbl_isempty(selected_entries) then
      notify.warn("No files scratchpads selected for removal! Select scratchpads using <Tab>.")
      return
    end

    local files_to_delete = {}
    for _, entry in ipairs(selected_entries) do
      table.insert(files_to_delete, entry.value)
    end

    local file_list = table.concat(files_to_delete, "\n")
    local input_prompt = "Are you sure you want to remove these scratchpads? (y/n)\n\n" .. file_list

    vim.ui.input({ prompt = input_prompt }, function(input)
      if input == "y" then
        for _, file in ipairs(files_to_delete) do
          os.remove(scratchpads_dir .. file)
        end

        notify.info("Removed scratchpads:\n\n" .. file_list)
      else
        notify.warn("Action to remove scratchpads cancelled.")
      end
    end)
  end

  telescope_search("Delete Scratchpad", {
    attach_mappings = function(_, map)
      map("i", "<CR>", delete_scratchpads)        -- Confirm deletion with <Enter>
      map("i", "<Tab>", actions.toggle_selection) -- Toggle selection with <Tab>
      map("n", "<CR>", delete_scratchpads)
      map("n", "<Tab>", actions.toggle_selection)

      return true
    end,
    multi_select = true,
  })
end

vim.api.nvim_create_user_command("ScratchNew", new_scratchpad, {})
vim.api.nvim_create_user_command("ScratchOpen", open_scratchpad, {})
vim.api.nvim_create_user_command("ScratchRename", rename_scratchpad, {})
vim.api.nvim_create_user_command("ScratchRemove", remove_scratchpad, {})
