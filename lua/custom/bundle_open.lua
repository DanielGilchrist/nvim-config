local notify = require("../utils/notify")
local notify_gem_list_id = "bundle-open-gem-list-id"

local function fetch_gem_list(callback)
  local gems = {}

  notify.info("Fetching gem list for " .. vim.fn.getcwd() .. "...", {
    id = notify_gem_list_id,
    timeout = false,
  })

  local function on_stdout(_, data)
    for _, line in ipairs(data) do
      if line ~= "" then
        table.insert(gems, line)
      end
    end
  end

  local function on_exit()
    notify.hide(notify_gem_list_id)
    callback(gems)
  end

  vim.fn.jobstart({ "bundle", "list", "--name-only" }, {
    stdout_buffered = true,
    on_stdout = on_stdout,
    on_exit = on_exit
  })
end

local function open_gem()
  local function open_selected_gem(selected)
    if selected then
      local cwd = vim.fn.getcwd()
      local cmd = string.format(
        "wezterm cli spawn --cwd=%s -- bundle open %s",
        vim.fn.shellescape(cwd),
        vim.fn.shellescape(selected)
      )

      vim.fn.system(cmd)
    end
  end

  fetch_gem_list(function(gems)
    require("telescope.pickers").new({}, {
      prompt_title = "Bundle Open",
      finder = require("telescope.finders").new_table({
        results = gems
      }),
      sorter = require("telescope.config").values.generic_sorter({}),
      layout_config = {
        width = function(_, max_columns, _)
          return math.min(max_columns - 40, 80)
        end,
        height = 0.4,
      },
      attach_mappings = function(prompt_bufnr, _map)
        local actions = require("telescope.actions")
        local state = require("telescope.actions.state")

        actions.select_default:replace(function()
          local selection = state.get_selected_entry()
          actions.close(prompt_bufnr)
          open_selected_gem(selection[1])
        end)
        return true
      end,
    }):find()
  end)
end

vim.api.nvim_create_user_command("BundleOpen", open_gem, {})
