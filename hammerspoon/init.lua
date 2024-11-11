print([[

 ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄            ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄
▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌          ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░▌     ▐░░▌▐░░░░░░░░░░░▌
▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌          ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀▀▀
▐░▌       ▐░▌▐░▌          ▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌▐░▌ ▐░▌▐░▌▐░▌
▐░▌   ▄   ▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄▄▄
▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌
▐░▌ ▐░▌░▌ ▐░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀▀▀
▐░▌▐░▌ ▐░▌▐░▌▐░▌          ▐░▌          ▐░▌          ▐░▌       ▐░▌▐░▌       ▐░▌▐░▌
▐░▌░▌   ▐░▐░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄
▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌
 ▀▀       ▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀
]])

if hs.location.servicesEnabled() then
  hs.location.get()
else
  hs.alert.show("Location Services are not enabled")
end

local util = require("util")
local hyper = require("hyper")
local wm = require("wm")
local localConfig = require("local_config")
local ime = require("ime")
local urlBookmarks = require("url_bookmarks")
-- local weather = require("weather")
local audioDevice = require("audio_device")
local clipboard = require("clipboard")
-- local clock = require("clock")
local vpnWatcher = require("vpn_watcher")
local cheatsheet = require("cheatsheet")
local caffeine = require("caffeine")
require("application_watcher")
local watcher = require("watcher")
-- local event = require("event")
local clippy = require("clippy")
clippy:init():start()

-- local brewWatcher = require("brew_watcher")
-- brewWatcher:init()

-- local privateTask = require("private")
-- privateTask:init()

local partial = hs.fnutils.partial
local switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true):setDefaultFilter({})) -- include minimized/hidden windows, current Space only

local function yabai(...)
  util.run("/opt/homebrew/bin/yabai", ...)
end

local cmdMappings = {
  { "f9", "Action Chooser", partial(clipboard.showActionChooser, clipboard) },
  { "up", "Audio Device Chooser", partial(audioDevice.show, audioDevice) },
  { "down", "Audio Device Switch", partial(audioDevice.switch, audioDevice) },
}

for _, v in ipairs(cmdMappings) do
  hs.hotkey.bind({ "cmd" }, table.unpack(v))
end

hs.hotkey.bind({ "alt" }, "tab", hs.hints.windowHints)
hs.hotkey.bind({ "alt" }, "\\", "yabai focus recent", function()
  yabai("-m", "window", "--focus", "recent")
end)

local hyperCmdMappings = {
  a = wm.showAllVisibleWindows,
  c = hs.toggleConsole,
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
    hs.reload()
    -- require("test")
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

local hyperMappings = {
  { "f1", "Launch apps", wm.launchApps },
  { "f2", "Move window to space", wm.moveWindowToSpace },
  -- { "f3", "Broadcast current weather", partial(weather.sayCurrentWeather, weather) },
  { "left", "Move window to left half", partial(wm.resize, "leftHalf") },
  { "right", "Move window to right half", partial(wm.resize, "rightHalf") },
  { "up", "Move window to top half", partial(wm.resize, "topHalf") },
  { "down", "Move window to bottom half", partial(wm.resize, "bottomHalf") },
  { "return", "Maximize window with margin", wm.maximizeWindowWithMargin },
  { "space", "Maximize all window with margin", wm.maximizeAllWindowWithMargin },
  { "tab", "Switch To Next Window", partial(switcher.next, switcher) },
  -- { "1", "Launch apps", partial(wm.switchWindow, 1) },
  -- { "2", "Launch apps", partial(wm.switchWindow, 2) },
  -- { "3", "Launch apps", partial(wm.switchWindow, 3) },
  { "/", "Show cheatsheet", partial(cheatsheet.toggle, cheatsheet) },
  { "pageup", "Volume up", util.volumeUp }, -- only native devices
  { "pagedown", "Volume down", util.volumeDown },
}

for _, v in ipairs(hyperMappings) do
  hyper:bind({}, table.unpack(v))
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
  {
    "delete", -- backspace
    "Yabai toggle space padding",
    function()
      yabai("-m", "space", "--toggle", "padding")
    end,
  },
  {
    "return",
    "Zoom fullscreen",
    function()
      yabai("-m", "window", "--toggle", "zoom-fullscreen")
    end,
  },
  {
    "f",
    "Toggle whether the focused window should be tiled",
    function()
      yabai("-m", "window", "--toggle", "float")
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
  { "left", "Move window to left half", partial(wm.resize, "leftHalf") },
  { "right", "Move window to right half", partial(wm.resize, "rightHalf") },
  { "up", "Move window to top half", partial(wm.resize, "topHalf") },
  { "down", "Move window to bottom half", partial(wm.resize, "bottomHalf") },
  {
    "p",
    "Switch to pinyin",
    function()
      hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
    end,
  },
  { "v", "Show clipboard history", partial(clipboard.show, clipboard) },
}

for _, v in ipairs(cmdShiftMappings) do
  hs.hotkey.bind({ "cmd", "shift" }, table.unpack(v))
end

hs.hotkey.bind({}, "f6", "Swap with window under cursor", partial(yabai, "-m", "window", "--swap", "mouse"))

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

-- hs.hotkey.bind({ "ctrl", "shift" }, "1", "open redmine", function()
--   openUrl(localConfig.urls.redmine, true)
-- end)
--
-- hs.hotkey.bind({ "ctrl", "shift" }, "2", "search in google", function()
--   openUrl("https://www.google.com/search?q=", true)
-- end)
--
-- hs.hotkey.bind({ "ctrl", "shift" }, "3", "open github", function()
--   openUrl("https://github.com")
-- end)

-- hs.hotkey.bind({ "cmd" }, "\\", function()
--   urlBookmarks:show()
-- end)

-- loadSpoon
hs.loadSpoon("SpoonInstall")
local Install = spoon.SpoonInstall

Install:andUse("ReloadConfiguration", { start = true })
Install:andUse("RoundedCorners", { start = true, config = { radius = 8 } })
-- Install:andUse("AClock", {
--   config = { showDuration = 3 },
--   fn = function(s)
--     hs.hotkey.bind({ "cmd", "shift" }, "t", nil, function()
--       s:toggleShow()
--     end)
--   end,
-- })
Install:andUse("KSheet", {
  hotkeys = {
    toggle = { { "cmd", "ctrl" }, "/" },
  },
})
Install:andUse("Emojis", {
  hotkeys = {
    toggle = { { "cmd", "ctrl" }, "e" },
  },
})
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

-- Install:andUse("ColorPicker", {
--   disable = false,
--   hotkeys = {
--     show = { { "cmd", "ctrl" }, "c" },
--   },
--   config = {
--     show_in_menubar = false,
--   },
--   start = true,
-- })

ime:init()
-- urlBookmarks:init()
-- weather:init(localConfig.weather.apiKey)
audioDevice:init()
clipboard:init()
-- clock:init()
vpnWatcher:init(localConfig.vpn_watcher.localIp, function()
  util.say("vpn Connected, my boss!")
end, function()
  util.say("vpn disconnected, my boss!")
end)
-- caffeine:init()
cheatsheet:init({
  hyperMappings = hyperMappings,
  cmdShiftMappings = cmdShiftMappings,
  appMappings = appMappings,
})
-- watcher:init()
-- event:init()

--
hs.alert.show("Hammerspoon Loaded!")
util.say("Hammerspoon is online")
hs.notify.new({ title = "Hammerspoon launch", informativeText = "Boss, at your service" }):send()

print("=> Hammerspoon Loaded!")
print([[

 ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄
▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌
▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌
▐░▌          ▐░▌▐░▌    ▐░▌▐░▌       ▐░▌
▐░█▄▄▄▄▄▄▄▄▄ ▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌
▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌
▐░█▀▀▀▀▀▀▀▀▀ ▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌
▐░▌          ▐░▌    ▐░▌▐░▌▐░▌       ▐░▌
▐░█▄▄▄▄▄▄▄▄▄ ▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌
▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌
 ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀
]])
