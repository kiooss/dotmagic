hs.window.animationDuration = 0

local mod = { "cmd", "alt" }
local hyper = require("hyper")

-- Hide all other applications
local function hideOtherApps()
  local activeApp = hs.application.frontmostApplication()
  local apps = hs.application.runningApplications()

  for _, app in ipairs(apps) do
    if app ~= activeApp then
      app:hide()
    end
  end
end

hyper:bind({}, "h", hideOtherApps)

-- Bind a hotkey to trigger the hideOtherApps function
hs.hotkey.bind(mod, "h", hideOtherApps)

local appMappings = {
  { "b", "Google Chrome" },
  { "e", "CotEditor" },
  { "f", "Finder" },
  { "s", "Slack" },
  { "t", "kitty" },
}

for i, km in ipairs(appMappings) do
  hyper.bindApp({}, km[1], km[2])
end

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
