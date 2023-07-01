local obj = {}
local util = require("util")

obj.timerHolder = {}

local function runJob()
  if hs.audiodevice.defaultOutputDevice():name() == "外部ヘッドフォン" then
    return
  end

  local soundFile = hs.fs.pathToAbsolute("~/Music/hhvoices/" .. os.date("%H%M") .. ".m4a")
  if soundFile then
    hs.sound.getByFile(soundFile):play()
  else
    util.say("Current time is " .. os.date("%H:%M"))
  end
end

function obj:init()
  for h = 7, 21 do
    table.insert(self.timerHolder, hs.timer.doAt(h .. ":00", "1d", runJob))
    table.insert(self.timerHolder, hs.timer.doAt(h .. ":30", "1d", runJob))
  end
end

return obj
