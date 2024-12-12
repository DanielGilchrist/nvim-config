local function merge_defaults(title, opts)
  opts = opts == nil and {} or opts

  return vim.tbl_extend("keep", opts, {
    title = title
  })
end

return {
  info = function(msg, opts)
    Snacks.notify.info(msg, merge_defaults("Information", opts))
  end,
  warn = function(msg, opts)
    Snacks.notify.warn(msg, merge_defaults("Warning", opts))
  end,
  error = function(msg, opts)
    Snacks.notify.error(msg, merge_defaults("Error", opts))
  end,
  hide = function(id)
    Snacks.notifier.hide(id)
  end
}
