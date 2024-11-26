return {
  info = function(msg, opts)
    Snacks.notify.info(msg, opts)
  end,
  warn = function(msg, opts)
    Snacks.notify.warn(msg, opts)
  end,
  error = function(msg, opts)
    Snacks.notify.error(msg, opts)
  end
}
