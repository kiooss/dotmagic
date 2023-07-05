local obj = {}
local config = require("local_config")
local slack = require("slack")
local util = require("util")

obj.interval = 60

function obj:getSlackStatus()
  -- local currentHour = tonumber(os.date("%H"))
  slack:users_getPresence(config.slack.uid, function(res)
    self.watchable.slack_status = res.presence
    local currentMinutes = tonumber(os.date("%M"))
    if currentMinutes % 5 == 0 then
      slack:chat_postMessage(
        config.slack.channel,
        string.format("*%s* Presence: *%s* idleTime: %d seconds", os.date("%H:%M:%S"), res.presence, hs.host.idleTime())
      )
    end
  end)
end

function obj:checkIdleTime()
  local seconds = hs.host.idleTime()
  util.d("idleTime: " .. seconds)
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
      local message =
        string.format("%s Slack status changed, now is *%s* (idleTime: %d seconds)", icon, newValue, hs.host.idleTime())
      util.d(message)
      hs.notify.new({ title = "Hammerspoon watcher", informativeText = message }):send()
      slack:chat_postMessage(config.slack.channel, message)

      if newValue == "away" then
        slack:chat_postMessage(config.slack.channel, "Enter x mode~")
        util.execute("~/.dotfiles/bin/x -d ~/workspace/osascript -a")
      end
    end
  end)
end

return obj
