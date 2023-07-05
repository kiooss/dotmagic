local obj = {}
local util = require("util")

function obj:init()
  local types = {
    hs.eventtap.event.types.keyUp,
    hs.eventtap.event.types.keyDown,
  }
  self.eventtap = hs.eventtap.new(types, self.handle)
  self.eventtap:start()
end

function obj.handle(event)
  print(event)
  local mods = hs.eventtap.checkKeyboardModifiers()
  util.d(mods)
end

return obj
