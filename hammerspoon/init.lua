hs.window.animationDuration = 0

local log = hs.logger.new("Hammerspoon", "debug")

local hyper = require("hyper")
local wm = require("wm")
local local_config = require("local_config")
require("input_methods")

local hyperCmdMappings = {
  c = function()
    hs.toggleConsole()
  end,
  d = function()
    hs.alert.show(wm.getCurrentAppName())
  end,
  r = function()
    hs.reload()
  end,
}

for key, item in pairs(hyperCmdMappings) do
  hyper:bind({ "cmd" }, key, item)
end

-- window manage
hyper:bind({}, "h", wm.moveOtherAppToNextScreen)

hyper:bind({}, "q", function()
  hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end)
hs.hotkey.bind({ "cmd", "alt" }, "p", function()
  -- log.d(hs.keycodes.currentSourceID())
  hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end)

-- app laucher
local appMappings = {
  b = "Google Chrome",
  c = "Google Chrome",
  e = "CotEditor",
  f = "Finder",
  s = "Slack",
  t = "kitty",
  p = "Microsoft PowerPoint",
  w = "WeChat",
  x = "Microsoft Excel",
  z = function()
    hs.execute("~/.dotfiles/bin/x -d ~/workspace/osascript -a")
  end,
}

for key, item in pairs(appMappings) do
  hyper.bindApp({}, key, item)
end

-- open url
local function openUrl(url, withClipboardContents)
  if withClipboardContents then
    url = url .. hs.pasteboard.getContents()
  end
  hs.alert.show(string.format("open website: %s", url))
  hs.urlevent.openURL(url)
end

hs.hotkey.bind({ "ctrl", "cmd" }, "1", "open redmine", function()
  openUrl(local_config.urls.redmine, true)
end)

hs.hotkey.bind({ "ctrl", "cmd" }, "2", "search in google", function()
  openUrl("https://www.google.com/search?q=", true)
end)

hs.hotkey.bind({ "ctrl", "cmd" }, "3", "open github", function()
  openUrl("https://github.com")
end)

-- Reacting to application events
-- local function applicationWatcher(appName, eventType, appObject)
--   if eventType == hs.application.watcher.activated then
--     if appName == "Finder" then
--       hs.alert.show("Finder")
--       -- Bring all Finder windows forward when one gets activated
--       appObject:selectMenuItem({ "Window", "Bring All to Front" })
--     end
--   end
-- end
-- local appWatcher = hs.application.watcher.new(applicationWatcher)
-- appWatcher:start()

-- loadSpoon
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

--
hs.alert.show("Hammerspoon Loaded!")
