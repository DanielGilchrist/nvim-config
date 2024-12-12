local notify = require("../utils/notify")

local function fetch_gem_list(callback)
  local gems = {}

  local function on_stdout(_, data)
    for _, line in ipairs(data) do
      if line ~= "" then
        table.insert(gems, line)
      end
    end
  end

  local function on_exit()
    callback(gems)
  end

  notify.info("Fetching gem list for " .. vim.fn.getcwd() .. "...", { timeout = 1000 })

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
