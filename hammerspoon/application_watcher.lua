local util = require("util")

local function applicationWatcher(appName, eventType, appObject)
  if eventType == hs.application.watcher.activated then
    if appName == "Finder" then
      local allWindows = appObject:allWindows()
      if #allWindows == 0 then
        -- new window
        util.run("/usr/bin/open", os.getenv("HOME") .. "/Downloads")
      end
    end
  end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
