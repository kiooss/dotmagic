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
