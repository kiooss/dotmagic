local audiochoices = {}
local util = require("util")

for i, v in ipairs(hs.audiodevice.allOutputDevices()) do
  util.d(v)

  table.insert(audiochoices, { text = v:name(), idx = i })
end

local audioChooser = hs.chooser.new(function(choice)
  if not choice then
    hs.alert.show("Nothing chosen")
    return
  end

  local idx = choice["idx"]
  local name = choice["text"]
  local dev = hs.audiodevice.allOutputDevices()[idx]
  if not dev:setDefaultOutputDevice() then
    hs.alert.show("Unable to enable audio output device: " .. name)
  else
    hs.alert.show("Audio output device is now: " .. name)
  end
end)

audioChooser:choices(audiochoices)

hs.hotkey.bind({ "cmd" }, "f12", function()
  audioChooser:placeholderText(hs.audiodevice.defaultOutputDevice():name())
  audioChooser:show()
end)
