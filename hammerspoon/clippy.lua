--- === Clippy ===
---
--- Copy last screenshot to clipboard and save to disk
---

local obj = {}
local util = require("util")

obj.screenshotPath = os.getenv("HOME") .. "/Documents/screenshots"

obj.newScreenshot = nil
obj.lastRuntime = 0

function obj.imageToClipboard(files, flagTables)
  if os.time() - obj.lastRuntime < 2 then
    print("DEBUG: Clippy pathwatcher debounced")
    return
  end
  util.d(files)
  util.d(flagTables)

  -- if #files ~= 2 then
  --   return
  -- end
  local filePath = files[2]

  obj.newScreenshot = hs.image.imageFromPath(filePath)
  -- util.d(obj.newScreenshot)
  hs.pasteboard.writeObjects(obj.newScreenshot)
  hs.notify
    .new({
      title = "Screenshot!",
      subtitle = "New screenshot detected",
      informativeText = "🚀 Screenshot copied to clipboard",
      alwaysPresent = true,
      autoWithdraw = true,
    })
    :send()

  obj.lastRuntime = os.time()
end

function obj:init()
  obj.screenshotWatcher = hs.pathwatcher.new(obj.screenshotPath, obj.imageToClipboard)
  return self
end

function obj:start() -- luacheck: ignore
  util.d("-- Starting Clippy")
  obj.screenshotWatcher:start()
end

function obj:stop()
  util.d("-- Stopping Clippy")
  obj.screenshotWatcher:stop()
end

function obj.disable()
  obj.screenshotWatcher:stop()
  obj.screenshotWatcher = nil
end

return obj
