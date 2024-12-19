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
    if selected and selected[1] then
      local cwd = vim.fn.getcwd()
      local cmd = string.format(
        "wezterm cli spawn --cwd=%s -- bundle open %s",
        vim.fn.shellescape(cwd),
        vim.fn.shellescape(selected[1])
      )
      vim.fn.system(cmd)
    end
  end

  fetch_gem_list(function(gems)
    require("fzf-lua").fzf_exec(gems, {
      prompt = "Bundle Open> ",
      actions = {
        ["default"] = open_selected_gem,
      },
      file_icons = false,
      git_icons = false,
      fzf_opts = {
        ["--layout"] = "reverse-list",
      },
      winopts = {
        width = 0.5,
        height = 0.4,
        row = 0.35,
        col = 0.5,
        border = "rounded",
      },
    })
  end)
end

vim.api.nvim_create_user_command("BundleOpen", open_gem, {})
