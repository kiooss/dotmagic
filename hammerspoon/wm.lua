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
  -- local frontmostApplication = hs.application.frontmostApplication()
  -- local frontmostApplicationWindow = frontmostApplication:focusedWindow()
  -- util.d(frontmostApplicationWindow)
  -- util.d(hs.window.focusedWindow() == frontmostApplicationWindow)

  if nextScreen ~= nil then
    hs.window.focusedWindow():moveToScreen(nextScreen)
  end
end

M.applyLayout = function()
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
