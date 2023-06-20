local log = hs.logger.new("󰣪 debug", "debug")
local inspect = hs.inspect.inspect

local M = {}

M.d = function(obj)
  if type(obj) == "table" then
    log.d(inspect(obj))
  else
    log.d(obj)
  end
end

M.split = function(input, delimiter)
  input = tostring(input)
  delimiter = tostring(delimiter)
  if delimiter == "" then
    return false
  end
  local pos, arr = 0, {}
  -- for each divider found
  for st, sp in
    function()
      return string.find(input, delimiter, pos, true)
    end
  do
    table.insert(arr, string.sub(input, pos, st - 1))
    pos = sp + 1
  end
  table.insert(arr, string.sub(input, pos))
  return arr
end

M.getFocusedBundleId = function()
  return hs.application.frontmostApplication():bundleID()
end

return M
