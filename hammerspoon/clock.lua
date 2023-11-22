local obj = {}
local util = require("util")

obj.timerHolder = {}

local function playSound(name)
  if hs.audiodevice.defaultOutputDevice():name() == "外部ヘッドフォン" then
    return
  end

  local soundFile = hs.fs.pathToAbsolute("~/Music/hhvoices/" .. name .. ".m4a")
  if soundFile then
    hs.sound.getByFile(soundFile):play()
  else
    util.say("Current time is " .. os.date("%H:%M"))
  end
end

function obj:init()
  for h = 7, 19 do
    table.insert(
      self.timerHolder,
      hs.timer.doAt(h .. ":00", "1d", function()
        playSound(string.format("%.2d00", h))
      end)
    )
    table.insert(
      self.timerHolder,
      hs.timer.doAt(h .. ":30", "1d", function()
        playSound(string.format("%.2d30", h))
      end)
    )
  end
end

return obj
