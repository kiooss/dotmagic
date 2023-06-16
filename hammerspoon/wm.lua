local M = {}
local log = hs.logger.new("wm", "debug")
-- local inspect = hs.inspect.inspect

M.getCurrentAppName = function()
  local window = hs.window.focusedWindow()
  if window then
    local app = window:application()
    return "App name: is " .. app:name() .. " bundle id: " .. app:bundleID()
  end
  return nil
end

M.moveOtherAppToNextScreen = function()
  local currentScreen = hs.screen.mainScreen()
  local nextScreen = currentScreen:next()
  local frontmostApplication = hs.application.frontmostApplication()
  local frontmostApplicationWindow = frontmostApplication:focusedWindow()
  local visiableWindows = hs.window.visibleWindows()

  -- log.d(currentScreen)
  -- log.d(nextScreen)
  -- log.d(frontmostApplication)
  -- log.d(frontmostApplicationWindow)
  -- log.d(hs.inspect.inspect(visiableWindows))

  for _, window in ipairs(visiableWindows) do
    -- Move the window to the next screen
    if window ~= frontmostApplicationWindow then
      window:moveToScreen(nextScreen)
    end
  end
end

return M
