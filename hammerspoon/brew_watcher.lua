local obj = {}
local config = require("local_config")
local slack = require("slack")
local util = require("util")

obj.interval = 300

function obj:init()
  slack:init(config.slack.token)
  self:checkBrewOutdated()
  self.timer = hs.timer
    .doAt("9:00", "1d", function()
      self:checkBrewOutdated()
    end)
    :start()
end

function obj:checkBrewOutdated()
  util.d("checkBrewOutdated")
  hs.task
    .new(
      "/usr/local/bin/brew",
      function(_, stdOut, stdErr)
        util.d(stdOut .. stdErr)
        if stdOut ~= nil or stdErr ~= nil then
          local message = string.format("*Outdated brew packages:*\n```%s```", stdOut .. stdErr)
          slack:chat_postMessage(config.slack.channel, message)
        end
      end,
      --   function(_, stdOut, stdErr)
      --   util.d(stdOut .. stdErr)
      --   slack:chat_postMessage(config.slack.channel, stdOut .. stdErr)
      --   return true
      -- end
      { "outdated", "-q" }
    )
    :start()
end

return obj
