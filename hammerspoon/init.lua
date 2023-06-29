hs.window.animationDuration = 0

local util = require("util")
local hyper = require("hyper")
local wm = require("wm")
local localConfig = require("local_config")
require("input_methods")
require("url_bookmarks")

local weather = require("weather")
weather:init(localConfig.weatherApiKey, localConfig.city)

local audioDevice = require("audio_device")
audioDevice:init()

local clipboard = require("clipboard")
clipboard:init()

local function yabai(...)
  util.run("/usr/local/bin/yabai", ...)
end

local hyperCmdMappings = {
  a = wm.showAllVisibleWindows,
  c = function()
    hs.toggleConsole()
  end,
  d = function() -- d for debug
    hs.alert.show("FocusedWindow: " .. wm.getCurrentAppName())
    hs.alert.show("FrontMostApp: " .. hs.application.frontmostApplication():name())
    -- local frontmostApplication = hs.application.frontmostApplication()
    -- A list of hs.window objects representing all visible windows, ordered from front to back
    local allWindows = hs.window.orderedWindows()

    util.d("=== ordered windows ===")
    for index, window in ipairs(allWindows) do
      util.d(index .. ": Application: " .. window:application():name())
      util.d(window)
    end
    util.d(hs.spaces.allSpaces())
  end,
  q = function()
    hs.notify.withdrawAll()
  end,
  r = function()
    -- hs.reload()
    require("test")
  end,
  s = function()
    hs.caffeinate.systemSleep()
  end,
  y = function()
    yabai("--restart-service")
  end,
  z = function()
    util.execute("~/.dotfiles/bin/x -d ~/workspace/osascript -a")
  end,
}

for key, item in pairs(hyperCmdMappings) do
  hyper:bind({ "cmd" }, key, item)
end

local switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter({})) -- include minimized/hidden windows, current Space only

local function switchWindow()
  switcher:next()
end

local hyperMappings = {
  { "f1", "Launch apps", wm.launchApps },
  { "f2", "Move window to space", wm.moveWindowToSpace },
  { "left", "Move window to left half", hs.fnutils.partial(wm.resize, "leftHalf") },
  { "right", "Move window to right half", hs.fnutils.partial(wm.resize, "rightHalf") },
  { "up", "Move window to top half", hs.fnutils.partial(wm.resize, "topHalf") },
  { "down", "Move window to bottom half", hs.fnutils.partial(wm.resize, "bottomHalf") },
  { "return", "Maximize window with margin", wm.maximizeWindowWithMargin },
  { "space", "Maximize all window with margin", wm.maximizeAllWindowWithMargin },
  { "tab", "Switch To Next Window", switchWindow },
  { "1", "Launch apps", hs.fnutils.partial(wm.switchWindow, 1) },
  { "2", "Launch apps", hs.fnutils.partial(wm.switchWindow, 2) },
  { "3", "Launch apps", hs.fnutils.partial(wm.switchWindow, 3) },
}

for _, v in ipairs(hyperMappings) do
  hyper:bind({}, v[1], v[2], v[3])
end

-- cmd + shift bindings
local cmdShiftMappings = {
  {
    "=",
    "Balance out all windows",
    function()
      yabai("-m", "space", "--balance")
    end,
  },
  {
    "\\",
    "Rotate the window tree clock-wise",
    function()
      yabai("-m", "space", "--rotate", "90")
    end,
  },
  { ";", "Move to next screen", wm.moveToNextScreen },
  {
    "h",
    "focusWindowWest",
    function()
      hs.window.focusedWindow():focusWindowWest()
    end,
  },
  {
    "l",
    "focusWindowEast",
    function()
      hs.window.focusedWindow():focusWindowEast()
    end,
  },
  {
    "j",
    "focusWindowSouth",
    function()
      hs.window.focusedWindow():focusWindowSouth()
    end,
  },
  {
    "k",
    "focusWindowNorth",
    function()
      hs.window.focusedWindow():focusWindowNorth()
    end,
  },
  {
    "p",
    "Switch to pinyin",
    function()
      hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
    end,
  },
}

for _, v in ipairs(cmdShiftMappings) do
  hs.hotkey.bind({ "cmd", "shift" }, v[1], v[2], v[3])
end

-- app laucher
local appMappings = {
  { "b", "Safari" },
  { "c", "Calendar" },
  { "e", "Microsoft Edge" },
  { "f", "Finder" },
  { "g", "Google Chrome" },
  { "m", "Microsoft Edge" },
  { "p", "Microsoft PowerPoint" },
  { "s", "Slack" },
  { "t", "kitty" },
  { "v", "FortiClient" },
  { "w", "WeChat" },
  { "x", "Microsoft Excel" },
  { ",", "System Preferences" },
}

for _, v in ipairs(appMappings) do
  hyper.bindApp({}, table.unpack(v))
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
  openUrl(localConfig.urls.redmine, true)
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
    toggle = { { "cmd", "ctrl" }, "/" },
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

local cheatsheet = require("cheatsheet")
cheatsheet:init({
  hyperMappings = hyperMappings,
  cmdShiftMappings = cmdShiftMappings,
  appMappings = appMappings,
})

hyper:bind({}, "/", nil, function()
  cheatsheet:toggle()
end)

--
-- hs.alert.show("Hammerspoon Loaded!")
require("speaker")