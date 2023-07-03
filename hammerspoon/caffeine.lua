local obj = {}
local c = hs.caffeinate

local sleepType = "systemIdle"

-- sleepType - A string containing the type of sleep to be configured. The value should be one of:
-- displayIdle - Controls whether the screen will be allowed to sleep (and also the system) if the user is idle.
-- systemIdle - Controls whether the system will be allowed to sleep if the user is idle (display may still sleep).
-- system - Controls whether the system will be allowed to sleep for any reason.

function obj:init()
  self.caffeine = hs.menubar.new()
  self.caffeine:setClickCallback(function()
    c.toggle(sleepType)
    self:setCaffeineDisplay()
  end)
  self:setCaffeineDisplay()
end

function obj:setCaffeineDisplay()
  local state = c.get("displayIdle") or c.get("systemIdle") or c.get("system")

  if state then
    self.caffeine:setTitle("AWAKE")
    self.caffeine:setIcon("./icons/caffeine-on.pdf")
  else
    self.caffeine:setTitle("SLEEPY")
    self.caffeine:setIcon("./icons/caffeine-off.pdf")
  end

  local tooltip = string.format(
    "Prevent sleep \n displayIdle: %s systemIdle: %s system: %s",
    c.get("displayIdle"),
    c.get("systemIdle"),
    c.get("system")
  )
  self.caffeine:setTooltip(tooltip)
end

return obj

-- ---@diagnostic disable: lowercase-global
-- ---
-- --- 控制空闲时是否允许屏幕睡眠
--
-- toggleCaffeine = function()
--   local c = hs.caffeinate
--   if not c then
--     return
--   end
--   if c.get("displayIdle") or c.get("systemIdle") or c.get("system") then
--     if menuCaff then
--       menuCaffRelease()
--     else
--       addMenuCaff()
--       local type
--       if c.get("displayIdle") then
--         type = "displayIdle"
--       end
--       if c.get("systemIdle") then
--         type = "systemIdle"
--       end
--       if c.get("system") then
--         type = "system"
--       end
--       hs.alert("Caffeine already on for " .. type)
--     end
--   else
--     acAndBatt = hs.battery.powerSource() == "Battery Power"
--     c.set("system", true, acAndBatt)
--     hs.alert("Caffeinated " .. (acAndBatt and "" or "on AC Power"))
--     addMenuCaff()
--   end
-- end
--
-- function addMenuCaff()
--   menuCaff = hs.menubar.new()
--   menuCaff:setIcon("./icons/caffeine-on.pdf")
--   menuCaff:setClickCallback(menuCaffRelease)
-- end
--
-- function menuCaffRelease()
--   local c = hs.caffeinate
--   if not c then
--     return
--   end
--   if c.get("displayIdle") then
--     c.set("displayIdle", false, true)
--   end
--   if c.get("systemIdle") then
--     c.set("systemIdle", false, true)
--   end
--   if c.get("system") then
--     c.set("system", false, true)
--   end
--   if menuCaff then
--     menuCaff:setIcon("./icons/caffeine-off.pdf")
--
--     -- menuCaff:delete()
--     -- menuCaff = nil
--   end
--   hs.alert("Decaffeinated", 0.5)
-- end
