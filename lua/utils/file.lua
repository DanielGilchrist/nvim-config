return {
  read = function(path)
    local file = io.open(path, "r")

    if not file then
      return nil
    end

    local contents = file:read("*a")
    file:close()

    return contents
  end
}
