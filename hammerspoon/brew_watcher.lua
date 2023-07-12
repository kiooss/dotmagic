local obj = {}
local config = require("local_config")
local slack = require("slack")
local util = require("util")

obj.interval = 300

function obj:init()
  slack:init(config.slack.token)
  self:checkBrewOutdated()
  self.timer = hs.timer
    .doAt("1:00", "1d", function()
      self:checkBrewOutdated()
    end)
    :start()
end

function obj:checkBrewOutdated()
  util.d("checkBrewOutdated")
  hs.task
    .new("/usr/local/bin/brew", function(...)
      print("exit", hs.inspect(table.pack(...)))
    end, function(_, stdOut, stdErr)
      util.d(stdOut)
      local message = string.format("*Outdated brew packages:*\n```%s```", stdOut .. stdErr)
      slack:chat_postMessage(config.slack.channel, message)
      return true
    end, { "outdated", "-q" })
    :start()
end

return obj
