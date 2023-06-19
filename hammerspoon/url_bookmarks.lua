local localConfig = require("local_config")
local util = require("util")

local urlChoices = {}
for i, v in ipairs(localConfig.bookmarks) do
  table.insert(urlChoices, { text = v[1], subText = v[2], idx = i })
end

local urlChooser = hs.chooser.new(function(choice)
  if not choice then
    hs.alert.show("Nothing chosen")
    return
  end

  local url = choice["subText"]
  hs.alert.show(string.format("open website: %s", url))
  hs.urlevent.openURL(url)
end)

urlChooser:choices(urlChoices)

hs.hotkey.bind({ "cmd" }, "\\", function()
  urlChooser:placeholderText("Happy everyday!")
  urlChooser:show()
end)
