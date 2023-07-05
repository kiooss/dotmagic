local util = require("util")
local config = require("local_config")
local slack = require("slack")

local obj = {}
local c = hs.caffeinate
local sleepType = "displayIdle"

-- sleepType - A string containing the type of sleep to be configured. The value should be one of:
-- displayIdle - Controls whether the screen will be allowed to sleep (and also the system) if the user is idle.
-- systemIdle - Controls whether the system will be allowed to sleep if the user is idle (display may still sleep).
-- system - Controls whether the system will be allowed to sleep for any reason.

function obj:init()
  slack:init(config.slack.token)
  self.caffeine = hs.menubar.new()
  self.caffeine:setClickCallback(function()
    c.toggle(sleepType)
    self:setCaffeineDisplay()
  end)
  self:setCaffeineDisplay()

  self.watcher = hs.caffeinate.watcher
    .new(function(event)
      if event == hs.caffeinate.watcher.systemWillSleep then
        slack:chat_postMessage(config.slack.channel, "Mac: system Will Sleep")
      end
    end)
    :start()
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
    "Prevent sleep\ndisplayIdle: %s\nsystemIdle: %s\nsystem: %s",
    c.get("displayIdle"),
    c.get("systemIdle"),
    c.get("system")
  )
  self.caffeine:setTooltip(tooltip)
end

return obj
