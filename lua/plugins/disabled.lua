local function disable_plugin(source)
  return { source, enabled = false }
end

return {
  disable_plugin("mrcjkb/rustaceanvim"),
}