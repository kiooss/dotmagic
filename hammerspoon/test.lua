-- local allWindows = hs.window.orderedWindows()
--
-- for index, window in ipairs(allWindows) do
--   require("util").mark(index, window)
-- end

-- local sounds = hs.sound.systemSounds()
--
-- for _, name in ipairs(sounds) do
--   hs.sound.getByName(name):play()
-- end

local util = require("util")

-- X = hs.wifi.watcher
--   .new(function(...)
--     util.d(...)
--   end)
--   :start()

util.mark("VPN")
