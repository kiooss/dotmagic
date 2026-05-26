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
-- Hyper modal moved to AeroSpace (Karabiner: Right Ctrl → cmd+alt+ctrl)
-- local hyper = require("hyper")
local wm = require("wm")
local localConfig = require("local_config")
local ime = require("ime")
local urlBookmarks = require("url_bookmarks")
-- local weather = require("weather")
local audioDevice = require("audio_device")
local clipboard = require("clipboard")
-- local clock = require("clock")
-- local vpnWatcher = require("vpn_watcher")
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
  { "right", "Action Chooser", partial(clipboard.showActionChooser, clipboard) },
  { "up", "Audio Device Chooser", partial(audioDevice.show, audioDevice) },
  { "down", "Audio Device Switch", partial(audioDevice.switch, audioDevice) },
}

for _, v in ipairs(cmdMappings) do
  hs.hotkey.bind({ "cmd" }, table.unpack(v))
end

-- hyperCmdMappings removed; Hyper key moved to AeroSpace.

-- hyperMappings removed; Hyper key moved to AeroSpace.

-- cmd + shift bindings
local cmdShiftMappings = {
  -- {
  --   "=",
  --   "Balance out all windows",
  --   function()
  --     yabai("-m", "space", "--balance")
  --   end,
  -- },
  -- {
  --   "\\",
  --   "Rotate the window tree clock-wise",
  --   function()
  --     yabai("-m", "space", "--rotate", "90")
  --   end,
  -- },
  -- {
  --   "delete", -- backspace
  --   "Yabai toggle space padding",
  --   function()
  --     yabai("-m", "space", "--toggle", "padding")
  --   end,
  -- },
  -- {
  --   "return",
  --   "Zoom fullscreen",
  --   function()
  --     yabai("-m", "window", "--toggle", "zoom-fullscreen")
  --   end,
  -- },
  -- {
  --   "f",
  --   "Toggle whether the focused window should be tiled",
  --   function()
  --     yabai("-m", "window", "--toggle", "float")
  --   end,
  -- },
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
  -- {
  --   "p",
  --   "Switch to pinyin",
  --   function()
  --     hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
  --   end,
  -- },
  { "v", "Show clipboard history", partial(clipboard.show, clipboard) },
}

for _, v in ipairs(cmdShiftMappings) do
  hs.hotkey.bind({ "cmd", "shift" }, table.unpack(v))
end

-- hs.hotkey.bind({}, "f6", "Swap with window under cursor", partial(yabai, "-m", "window", "--swap", "mouse"))

-- App launchers moved to AeroSpace (cmd-alt-ctrl-<letter> exec-and-forget).
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
-- Install:andUse("KSheet", {
--   hotkeys = {
--     toggle = { { "cmd", "ctrl" }, "/" },
--   },
-- })
-- Install:andUse("Emojis", {
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
-- vpnWatcher:init(localConfig.vpn_watcher.localIp, function()
--   util.say("Connected")
-- end, function()
--   util.say("Disconnected")
-- end)
-- caffeine:init()
cheatsheet:init({
  cmdShiftMappings = cmdShiftMappings,
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
