local hyper = hs.hotkey.modal.new({}, nil)

local log = hs.logger.new("hammerspoon", "debug")

local function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
end

local function exitHyperMode()
  hyper:exit()
  if not hyper.triggered then
    hs.eventtap.keyStroke({}, "ESCAPE")
  end
end

-- Bind the Hyper key
-- Set the key you want to be HYPER to F18 in karabiner or keyboard
-- Bind the Hyper key to the hammerspoon modal
hs.hotkey.bind({}, "F18", enterHyperMode, exitHyperMode)

hyper.bindApp = function(mods, key, app)
  local fn

  if type(app) == "function" then
    fn = app
  else
    fn = function()
      log.i("launch app: ", app)
      hs.application.launchOrFocus(app)
    end
  end

  hyper:bind(mods, key, fn)
end

return hyper
