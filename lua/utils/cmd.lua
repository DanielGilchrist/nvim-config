return {
  time_worked_cmd = function()
    local command = "tanda_cli time_worked week 2>/dev/null"
    local zsh_command = "zsh -ic '" .. command .. "'" -- zsh is a pain in the ass
    return command .. " || " .. zsh_command .. " || " .. "echo \"tanda_cli isn't setup!\""
  end
}
