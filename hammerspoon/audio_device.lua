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

  hs.hotkey.bind({}, "f13", "Switch audio output", function()
    obj:switch()
  end)
end

function obj:show()
  self.audioChooser:choices(obj.getAudioChoices())
  self.audioChooser:placeholderText("Select audio output device")
  self.audioChooser:show()
end

function obj:switch()
  local name_1 = "PHL 27E1N8900"
  local name_2 = "外置耳机"
  local next_name
  util.d(hs.audiodevice.current())
  local current = hs.audiodevice.current()["device"]
  util.d(current:name())
  if current:name() == name_1 then
    next_name = name_2
  else
    next_name = name_1
  end
  util.d(next_name)

  if hs.audiodevice.findDeviceByName(next_name):setDefaultOutputDevice() then
    hs.alert.show("Audio output switched to: " .. hs.audiodevice.current()["device"]:name())
  end
end

return obj
