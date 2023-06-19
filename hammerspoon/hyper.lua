-- Create a new modal keybinding mode
local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function()
  hyper:enter()
end

hyper.released = function()
  hyper:exit()
end

-- Bind the Hyper key
-- Set the key you want to be HYPER to F18 in karabiner or keyboard
-- Bind the Hyper key to the hammerspoon modal
hs.hotkey.bind({}, "F18", hyper.pressed, hyper.released)

hyper.bindApp = function(mods, key, app)
  hyper:bind(mods, key, "Launch " .. app, function()
    local ret = hs.application.launchOrFocus(app)
    if not ret then
      hs.alert.show("Launch app: " .. app .. " failed!")
    end
  end)
end

return hyper
