local util = require("util")

local obj = {}
obj.audioChooser = nil

function obj.getAudioChoices()
  local choices = {}
  for i, v in ipairs(hs.audiodevice.allOutputDevices()) do
    util.d(v)
    local subText = ""
    if v:name() == hs.audiodevice.defaultOutputDevice():name() then
      subText = "🔊"
    end
    if not string.find(v:name(), "Teams") and not string.find(v:name(), "Zoom") then
      table.insert(choices, { text = v:name(), subText = subText, idx = i })
    end
  end

  return choices
end

function obj:init()
  self.audioChooser = hs.chooser.new(function(choice)
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
end

function obj:show()
  self.audioChooser:choices(obj.getAudioChoices())
  self.audioChooser:placeholderText("Select audio output device")
  self.audioChooser:show()
end

return obj
