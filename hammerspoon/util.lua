local log = hs.logger.new("util", "debug")
local inspect = hs.inspect.inspect

return {
  d = function(obj)
    if type(obj) == "table" then
      log.d(inspect(obj))
    else
      log.d(obj)
    end
  end,
}
