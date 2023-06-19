hs.window.animationDuration = 0

local hyper = require("hyper")
local wm = require("wm")
local local_config = require("local_config")
require("input_methods")

local hyperCmdMappings = {
  a = wm.showAllVisibleWindows,
  c = function()
    hs.toggleConsole()
  end,
  d = function()
    hs.alert.show("FocusedWindow: " .. wm.getCurrentAppName())
    hs.alert.show("FrontMostApp: " .. hs.application.frontmostApplication():name())
    -- local frontmostApplication = hs.application.frontmostApplication()
  end,
  q = function()
    hs.notify.withdrawAll()
  end,
  r = function()
    hs.reload()
  end,
  s = function()
    hs.caffeinate.systemSleep()
  end,
  z = function()
    hs.execute("~/.dotfiles/bin/x -d ~/workspace/osascript -a")
  end,
}

for key, item in pairs(hyperCmdMappings) do
  hyper:bind({ "cmd" }, key, item)
end

-- window manage
hyper:bind({}, "h", wm.moveOtherAppToNextScreen)
hyper:bind({}, "tab", wm.moveToNextScreen)
hyper:bind({}, "return", wm.maximizeWindowWithMargin)
hyper:bind({}, "a", wm.applyLayout)
hyper:bind({}, "left", function()
  wm.resize("leftHalf")
end)
hyper:bind({}, "right", function()
  wm.resize("rightHalf")
end)
hyper:bind({}, "up", function()
  wm.resize("topHalf")
end)
hyper:bind({}, "down", function()
  wm.resize("bottomHalf")
end)
-- hyper:bind({ "cmd" }, "b", wm.applyBspLayout)

hyper:bind({}, "q", function()
  hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end)
hs.hotkey.bind({ "cmd" }, "p", function()
  -- log.d(hs.keycodes.currentSourceID())
  hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end)

-- app laucher
local appMappings = {
  b = "Safari",
  c = "Calendar",
  -- e = "CotEditor",
  e = "Microsoft Edge",
  f = "Finder",
  g = "Google Chrome",
  m = "Microsoft Edge",
  p = "Microsoft PowerPoint",
  s = "Slack",
  t = "kitty",
  v = "FortiClient",
  w = "WeChat",
  x = "Microsoft Excel",
  [","] = "System Preferences",
}

for key, item in pairs(appMappings) do
  hyper.bindApp({}, key, item)
end

-- hyper.bindApp({}, ",", "System Preferences")
-- open url
local function openUrl(url, withClipboardContents)
  local hsHttp = require("hs.http")

  if withClipboardContents then
    local str = hs.pasteboard.getContents()
    if #str > 200 then
      hs.alert.show("Too many content in clipboard!")
      return
    else
      url = url .. hsHttp.encodeForQuery(hs.pasteboard.getContents())
    end
  end
  hs.alert.show(string.format("open website: %s", url))
  hs.urlevent.openURL(url)
end

hs.hotkey.bind({ "ctrl", "shift" }, "1", "open redmine", function()
  openUrl(local_config.urls.redmine, true)
end)

hs.hotkey.bind({ "ctrl", "shift" }, "2", "search in google", function()
  openUrl("https://www.google.com/search?q=", true)
end)

hs.hotkey.bind({ "ctrl", "shift" }, "3", "open github", function()
  openUrl("https://github.com")
end)

-- Reacting to application events
-- local function applicationWatcher(appName, eventType, appObject)
--   hs.alert.show(appName)
--   if eventType == hs.application.watcher.activated then
--     if appName == "Finder" then
--       hs.alert.show("Finder")
--       -- Bring all Finder windows forward when one gets activated
--       appObject:selectMenuItem({ "Window", "Bring All to Front" })
--     elseif appName == "kitty" then
--       hs.alert.show("Finder")
--     end
--   end
-- end
-- local appWatcher = hs.application.watcher.new(applicationWatcher)
-- appWatcher:start()

-- hs.window.highlight.ui.overlay = true
-- hs.window.highlight.start()

-- loadSpoon
hs.loadSpoon("SpoonInstall")
local Install = spoon.SpoonInstall

Install:andUse("ReloadConfiguration", { start = true })
Install:andUse("RoundedCorners", { start = true, config = { radius = 8 } })
Install:andUse("AClock", {
  config = { showDuration = 3 },
  fn = function(clock)
    hs.hotkey.bind({}, "f12", nil, function()
      clock:toggleShow()
    end)
  end,
})
Install:andUse("KSheet", {
  hotkeys = {
    toggle = { hyper, "/" },
  },
})
-- Install:andUse("Emojis", {
--   disable = true,
--   hotkeys = {
--     toggle = { { "cmd", "ctrl" }, "e" },
--   },
-- })
-- Install:andUse("DeepLTranslate", {
--   disable = true,
--   config = {
--     -- popup_style = wm.utility | wm.HUD | wm.titled | wm.closable | wm.resizable,
--   },
--   hotkeys = {
--     -- translate = { { "cmd", "ctrl" }, "e" },
--     translate = { { "cmd", "ctrl" }, "e" },
--   },
-- })

Install:andUse("ColorPicker", {
  disable = false,
  hotkeys = {
    show = { { "cmd", "ctrl" }, "c" },
  },
  config = {
    show_in_menubar = false,
  },
  start = true,
})

--
hs.alert.show("Hammerspoon Loaded!")
