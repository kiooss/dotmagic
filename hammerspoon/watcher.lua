print("Loading watcher")

local obj = {}
local config = require("local_config")
local slack = require("slack")
local util = require("util")

obj.interval = 60
obj.id = nil
obj.lastChangedAt = nil

function obj:getSlackStatus()
  -- local currentHour = tonumber(os.date("%H"))
  slack:users_getPresence(config.slack.uid, function(res)
    self.watchable.slack_status = res.presence
    local currentMinutes = tonumber(os.date("%M"))
    if util.isWorkingHours() and currentMinutes % 5 == 0 and res.presence == "away" then
      slack:chat_postMessage(
        config.slack.channel,
        string.format(
          "*%s* ‼️P presence: *%s* idleTime: %d seconds",
          os.date("%H:%M:%S"),
          res.presence,
          hs.host.idleTime()
        )
      )
    end
  end)
end

function obj:checkIdleTime()
  local seconds = hs.host.idleTime()
  util.d(string.format("idleTime: %d seconds", seconds))
  if util.isWorkingHours() and seconds >= 600 then
    hs.eventtap.keyStroke({}, "escape")
    util.d(string.format("idleTime after keyStroke: %d seconds", hs.host.idleTime()))
  end
end

function obj:init()
  slack:init(config.slack.token)
  self.watchable = hs.watchable.new("status")

  self:getSlackStatus()
  obj.timer = hs.timer
    .doEvery(self.interval, function()
      self:getSlackStatus()
      self:checkIdleTime()
    end)
    :start()

  self.watcher = hs.watchable.watch("status", "slack_status", function(_, _, _, oldValue, newValue)
    if oldValue ~= nil then
      local icon = "❗️"
      if newValue == "active" then
        icon = "✅"
      end

      local elapsedTime = 0
      if self.lastChangedAt ~= nil then
        elapsedTime = os.time() - self.lastChangedAt
      end

      local message = string.format(
        "%s Slack status changed, now is *%s* \nidleTime: *%s*\n%s time: *%s*",
        icon,
        newValue,
        oldValue,
        util.secondsToClock(hs.host.idleTime()),
        util.secondsToClock(elapsedTime)
      )
      util.d(message)
      hs.notify.new({ title = "Hammerspoon watcher", informativeText = message }):send()
      slack:chat_postMessage(config.slack.channel, message)

      if newValue == "away" then
        util.brightnessDown()
      else
        util.brightnessUp()
      end

      self.lastChangedAt = os.time()
    end
  end)
end

return obj
