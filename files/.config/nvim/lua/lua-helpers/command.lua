local function command(key, value)
  vim.cmd(string.format('command %s %s', key, value))
end

local function set(key, value)
  if value == true or value == nil then
    vim.cmd(string.format('set %s', key))
  elseif value == false then
    vim.cmd(string.format('set no%s', key))
  else
    vim.cmd(string.format('set %s=%s', key, value))
  end
end

return {
  command = command,
  set = set
}
