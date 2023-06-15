local mod = { "cmd", "alt" }
local log = hs.logger.new("debug")

local hyper = require("hyper")
local vm = require("vm")
local local_config = require("local_config")

hs.window.animationDuration = 0
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("ReloadConfiguration", { start = true })
spoon.SpoonInstall:andUse("RoundedCorners", { start = true, config = { radius = 8 } })
spoon.SpoonInstall:andUse("AClock", {
  config = { showDuration = 3 },
  fn = function(clock)
    hyper:bind({}, "1", function()
      clock:toggleShow()
    end)
  end,
})

hyper:bind({}, "h", vm.hideOtherApps)
hyper:bind({}, "d", function()
  hs.alert.show(vm.getCurrentAppName())
end)

local appMappings = {
  { "b", "Google Chrome" },
  { "c", "Google Chrome" },
  { "e", "CotEditor" },
  { "f", "Finder" },
  { "s", "Slack" },
  { "t", "kitty" },
  { "p", "Microsoft PowerPoint" },
  { "x", "Microsoft Excel" },
}

for i, km in ipairs(appMappings) do
  hyper.bindApp({}, km[1], km[2])
end

local function openUrlWithClipboardContents(url)
  url = url .. hs.pasteboard.getContents()
  hs.alert.show(string.format("open website: %s", url))
  hs.urlevent.openURL(url)
end

hs.hotkey.bind({ "ctrl", "cmd" }, "1", "open redmine", function()
  openUrlWithClipboardContents(local_config.urls.redmine)
end)

hs.hotkey.bind({ "ctrl", "cmd" }, "2", "search in google", function()
  openUrlWithClipboardContents("https://www.google.com/search?q=")
end)

hs.hotkey.bind({ "ctrl", "cmd" }, "3", "open github", function()
  local url = "https://github.com/"
  hs.alert.show(string.format("open website: %s", url))
  hs.urlevent.openURL(url)
end)

--
hs.alert.show("Hammerspoon Loaded!")
