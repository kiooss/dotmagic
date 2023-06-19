local util = require("util")

local clipboard = hs.chooser.new(function(choice)
  if choice then
    hs.pasteboard.setContents(choice.content)
    hs.eventtap.keyStroke({ "cmd" }, "v")
  end
end)

local history = {}

local function addHistoryFromPasteboard()
  local contentTypes = hs.pasteboard.contentTypes()
  util.d(contentTypes)

  local item = {}
  for _, uti in ipairs(contentTypes) do
    if uti == "public.utf8-plain-text" then
      local text = hs.pasteboard.readString()
      item.text = string.gsub(text, "[\r\n]+", " ")
      item.content = text
      break
    end
  end

  table.insert(history, 1, item)
end

local preChangeCount = hs.pasteboard.changeCount()
-- util.d("preChangeCount: " .. preChangeCount)

local watcher = hs.timer.new(1, function()
  local changeCount = hs.pasteboard.changeCount()
  util.d("changeCount: " .. changeCount)
  if preChangeCount ~= changeCount then
    addHistoryFromPasteboard()
    preChangeCount = changeCount
  end
end)
watcher:start()

-- local generalPBWatcher = hs.pasteboard.watcher.new(function(v)
--   print(string.format("General Pasteboard Contents: %s", v))
--   util.d("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
-- end)
-- generalPBWatcher:start()
-- hs.pasteboard.writeObjects("This is on the general pasteboard.")

hs.hotkey.bind({ "cmd", "shift" }, "v", function()
  clipboard:choices(history)
  clipboard:show()
end)
