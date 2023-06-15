local M = {}
-- local log = hs.logger.new("hammerspoon", "debug")
-- local inspect = hs.inspect.inspect

M.getCurrentAppName = function()
  local window = hs.window.focusedWindow()
  if window then
    local app = window:application()
    return app:name()
  end
  return nil
end

-- Hide all other applications
M.hideOtherApps = function()
  local activeApp = hs.application.frontmostApplication()
  local apps = hs.application.runningApplications()

  for _, app in ipairs(apps) do
    if app ~= activeApp then
      app:hide()
    end
  end
end

return M
