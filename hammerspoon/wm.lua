local M = {}
local util = require("util")
local wm_helper = require("wm_helper")
local hsWindow = require("hs.window")
-- local hsScreen = require("hs.screen")
-- local hsLayout = require("hs.layout")

-- Function to maximize the frontmost window with a margin
M.maximizeWindowWithMargin = function()
  local focusedWindow = hsWindow.frontmostWindow()
  if focusedWindow then
    local screen = focusedWindow:screen()
    local frame = screen:frame()

    focusedWindow:setFrame(wm_helper.addMargin(frame))
  end
end

M.maximizeAllWindowWithMargin = function()
  local allWindows = hs.window.orderedWindows()
  for _, window in ipairs(allWindows) do
    util.d(window)
    util.d("Application: " .. window:application():name())
    local screen = window:screen()
    local frame = screen:frame()

    window:setFrame(wm_helper.addMargin(frame))
  end
end

M.moveWindowToSpace = function()
  --
  hs.alert.show("moveWindowToSpace")

  local apps = {
    { "net.kovidgoyal.kitty", 1 },
    { "com.google.Chrome", 3 },
    { "com.tinyspeck.slackmacgap", 4 },
  }
  for _, item in ipairs(apps) do
    local bundleID = item[1]
    local app = hs.application.get(bundleID)
    if app ~= nil then
      for _, window in ipairs(app:allWindows()) do
        util.d(window)
        if not hs.spaces.moveWindowToSpace(window, item[2]) then
          hs.alert.show(string.format("Move app: %s to space %s failed.", app:name(), item[2]))
        end
      end
    else
      hs.alert.show("App: " .. bundleID .. " is not running.")
    end
  end
  hs.spaces.gotoSpace(1)
end

M.resize = function(position)
  local focusedWindow = hsWindow.frontmostWindow()
  if focusedWindow then
    local winFrame = focusedWindow:frame()

    local screen = focusedWindow:screen()
    local screenFrame = screen:frame()
    local positions = {
      leftHalf = function()
        return wm_helper.leftHalf(winFrame, screenFrame)
      end,
      rightHalf = function()
        return wm_helper.rightHalf(winFrame, screenFrame)
      end,
      topHalf = function()
        return wm_helper.topHalf(winFrame, screenFrame)
      end,
      bottomHalf = function()
        return wm_helper.bottomHalf(winFrame, screenFrame)
      end,
    }

    focusedWindow:setFrame(positions[position]())
  end
end

M.getCurrentAppName = function()
  local window = hs.window.focusedWindow()
  if window then
    local app = window:application()
    util.d("App name: is " .. app:name() .. " bundle id: " .. app:bundleID())
    return "App name: is " .. app:name() .. " bundle id: " .. app:bundleID()
  end
  return nil
end

M.showAllVisibleWindows = function()
  for _, window in ipairs(hsWindow.visibleWindows()) do
    hs.alert.show(window:application():name() .. " [" .. window:title() .. "]")
  end
end

M.moveOtherAppToNextScreen = function()
  local currentScreen = hs.screen.mainScreen()
  local nextScreen = currentScreen:next()
  local focusedWindow = hs.window.focusedWindow()
  -- local frontmostApplication = hs.application.frontmostApplication()
  -- local frontmostApplicationWindow = frontmostApplication:focusedWindow()
  local visiableWindows = hs.window.visibleWindows()

  for _, window in ipairs(visiableWindows) do
    -- Move the window to the next screen
    if window ~= focusedWindow then
      window:moveToScreen(nextScreen)
    end
  end
end

M.moveToNextScreen = function()
  local currentScreen = hs.screen.mainScreen()
  local nextScreen = currentScreen:next()
  util.d(currentScreen)
  util.d(nextScreen)
  -- local frontmostApplication = hs.application.frontmostApplication()
  -- local frontmostApplicationWindow = frontmostApplication:focusedWindow()
  -- util.d(frontmostApplicationWindow)
  -- util.d(hs.window.focusedWindow() == frontmostApplicationWindow)

  if nextScreen ~= nil then
    hs.window.focusedWindow():moveToScreen(nextScreen)
  end
end

-- Function to switch focus to the next window
M.switchToNextWindow = function()
  -- Get all windows
  local windows = hs.window.orderedWindows()
  util.d(windows)

  -- Get the currently focused window
  local focusedWindow = hs.window.focusedWindow()

  -- Find the index of the focused window in the list
  local focusedIndex = nil
  for i, window in ipairs(windows) do
    if window == focusedWindow then
      focusedIndex = i
      break
    end
  end

  -- Determine the index of the next window
  local nextIndex = focusedIndex and focusedIndex + 1 or 1
  if nextIndex > #windows then
    nextIndex = 1
  end

  -- Focus the next window
  local nextWindow = windows[nextIndex]
  if nextWindow then
    nextWindow:focus()
  end
end

M.launchApps = function()
  -- local currentScreen = hs.screen.mainScreen()
  -- local nextScreen = currentScreen:next()
  local mainScreen = "PHL 27E1N8900"
  local subScreen = "LG Ultra HD"
  local adjustMargin = function(window)
    local screen = window:screen()
    local frame = screen:frame()

    return wm_helper.addMargin(frame)
  end
  local layout = {
    -- { "kitty", nil, currentScreen, hs.layout.maximized, nil, nil },
    { "Google Chrome", nil, subScreen, nil, adjustMargin, nil },
    { "kitty", nil, mainScreen, nil, adjustMargin, nil },
    { "Slack", nil, mainScreen, nil, adjustMargin, nil },
  }
  for _, item in ipairs(layout) do
    hs.application.launchOrFocus(item[1])
  end

  hs.layout.apply(layout)
end

-- M.applyBspLayout = function()
--   local windows = hs.window.allWindows()
--   local screenFrame = hs.screen.mainScreen():frame()
--   local layout = hsLayout.bsp.new(screenFrame)
--
--   layout:pushRegions(#windows)
--   for i, window in ipairs(windows) do
--     local region = layout:getRegion(i)
--     window:setFrame(region, 0)
--   end
-- end

return M
