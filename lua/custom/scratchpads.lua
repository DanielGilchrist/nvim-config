local notify = require("../utils/notify")
local scratchpads_dir = vim.fn.expand("~/.local/share/scratchpads/")
local fzf = require("fzf-lua")

local function clean_filename(filename)
  -- Remove icon prefix (everything up to and including first space)
  return filename:gsub("^[^ ]* ", "")
end

local function fzf_search(title, opts)
  opts = opts or {}

  local base_opts = {
    prompt = title .. "> ",
    cwd = scratchpads_dir,
    cmd = "fd -t f",
    actions = {
      ["default"] = opts.default_action,
    }
  }

  if opts.multi_select then
    base_opts.fzf_opts = {
      ["--multi"] = "",
      ["--marker"] = "▸",
    }
  end

  fzf.files(vim.tbl_deep_extend("force", base_opts, opts))
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
    fzf_search("Search Scratchpads", {
      default_action = function(selected)
        notify.warn(vim.inspect(selected))
        if selected and selected[1] then
          vim.cmd("edit " .. scratchpads_dir .. clean_filename(selected[1]))
        end
      end
    })
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
  local function delete_scratchpads(selected)
    notify.error(vim.inspect(selected))

    if not selected or #selected == 0 then
      notify.warn("No scratchpads selected for removal!")
      return
    end

    -- Clean up filenames for both display and operations
    local cleaned_files = {}
    for i, file in ipairs(selected) do
      notify.error(vim.inspect(file))
      cleaned_files[i] = clean_filename(file)
    end

    local file_list = table.concat(cleaned_files, "\n")
    local input_prompt = "Are you sure you want to remove these scratchpads? (y/n)\n\n" .. file_list

    vim.ui.input({ prompt = input_prompt }, function(input)
      if input == "y" then
        for _, file in ipairs(cleaned_files) do
          local full_path = scratchpads_dir .. file
          local success, err = os.remove(full_path)
          if not success then
            notify.error(string.format("Failed to remove %s: %s", file, err))
          else
            notify.info(string.format("Removed %s", file))
          end
        end
        notify.info("Removed scratchpads:\n\n" .. file_list)
      else
        notify.warn("Action to remove scratchpads cancelled.")
      end
    end)
  end

  fzf_search("Delete Scratchpad", {
    multi_select = true,
    default_action = delete_scratchpads,
    keymap = {
      ["toggle-select"] = { "<Tab>", "<S-Tab>" },
    }
  })
end

vim.api.nvim_create_user_command("ScratchNew", new_scratchpad, {})
vim.api.nvim_create_user_command("ScratchOpen", open_scratchpad, {})
vim.api.nvim_create_user_command("ScratchRename", rename_scratchpad, {})
vim.api.nvim_create_user_command("ScratchRemove", remove_scratchpad, {})
