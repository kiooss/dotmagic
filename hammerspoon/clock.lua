local obj = {}
local util = require("util")

obj.timerHolder = {}

local function runJob()
  util.say("Current time is " .. os.date("%H:%M"))
end

function obj:init()
  for h = 8, 20 do
    table.insert(self.timerHolder, hs.timer.doAt(h .. ":00", "1d", runJob))
    table.insert(self.timerHolder, hs.timer.doAt(h .. ":30", "1d", runJob))
  end
end

return obj
