hs.alert.defaultStyle.strokeColor = { white = 1, alpha = 0 }
hs.alert.defaultStyle.fillColor = { white = 0.05, alpha = 0.75 }
hs.alert.defaultStyle.radius = 5
hs.alert.defaultStyle.fadeOutDuration = 0.5
hs.alert.defaultStyle.textFont = "Input Mono"

hs.hints.fontName = "Input Mono"
hs.hints.fontSize = 24.0

hs.window.animationDuration = 0.1

hs.console.consoleFont("Input Mono")

-- loglevel - (optional) can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose',
-- or a corresponding number between 0 and 5; uses hs.logger.defaultLogLevel if omitted
hs.logger.defaultLogLevel = "warning"
local log = hs.logger.new("🛠", "debug")
-- say -v '?'
local speaker = hs.speech.new("Samantha")
local inspect = hs.inspect.inspect
D = hs.inspect.inspect

local M = {}

M.say = function(message)
  speaker:speak(message)
end

M.d = function(...)
  for _, obj in ipairs({ ... }) do
    if type(obj) == "table" then
      log.d(inspect(obj))
    else
      log.d(obj)
    end
  end
end

M.iMessage = function(message)
  hs.messages.iMessage(require("local_config").iMessageTarget, message)
end

M.execute = function(cmd)
  local output, status = hs.execute(cmd .. " 2>&1")
  if not status then
    local message = string.format("Execute cmd: %s failed.\nOutput: %s", cmd, output)
    hs.alert.show(message)
    M.d(message)
  end
end

M.mark = function(str)
  local width = 200
  local height = 100
  local canvas = hs.canvas.new({ x = 0, y = 0, h = 0, w = 0 })
  canvas[1] = {
    type = "text",
    text = str,
    textFont = "Impact",
    textSize = 80,
    textColor = { hex = "#1891C3" },
    textAlignment = "right",
  }
  local mainScreen = hs.screen.primaryScreen()
  local mainRes = mainScreen:fullFrame()
  canvas:frame({
    x = mainRes.w - width - 20,
    y = 25,
    w = width,
    h = height,
  })
  canvas:alpha(0.8)
  canvas:show()
end

M.run = function(cmd, ...)
  -- Runs in background very fast
  hs.task
    .new(cmd, nil, function(ud, ...)
      print("stream", hs.inspect(table.pack(...)))
      return true
    end, { ... })
    :start()
end

M.getFocusedBundleId = function()
  return hs.application.frontmostApplication():bundleID()
end

M.sendSlackMessage = function(message)
  local url = "https://slack.com/api/chat.postMessage"
  local config = require("local_config").slack
  local data = hs.json.encode({
    channel = config.channel,
    text = message,
  })
  print(data)
  local headers = {
    ["Content-type"] = "application/json",
    Authorization = "Bearer " .. config.token,
  }
  hs.http.asyncPost(url, data, headers, function(code, body, headers)
    print(code, body)
  end)
end

M.isWorkingHours = function()
  local wday = tonumber(os.date("%w"))
  if wday < 1 or wday > 5 then
    return false
  end

  local hour = tonumber(os.date("%H"))
  if hour > 18 or hour < 9 then
    return false
  end

  return true
end

M.brightnessUp = function()
  M.d("brightnessUp")
  hs.timer.doAfter(0.1, function()
    local result = hs.osascript.applescript([[
    tell application "System Events"
        repeat 16 times
            key code 144
        end repeat
    end tell
  ]])
    M.d(result)
  end)
end

M.brightnessDown = function()
  hs.osascript.applescript([[
    tell application "System Events"
        repeat 14 times
            key code 145
        end repeat
    end tell
  ]])
end

M.secondsToClock = function(seconds)
  -- local days = math.floor(seconds / 86400)
  -- seconds = seconds - days * 86400
  local hours = math.floor(seconds / 3600)
  seconds = seconds - hours * 3600
  local minutes = math.floor(seconds / 60)
  seconds = seconds - minutes * 60

  -- return string.format("%d days, %d hours, %d minutes, %d seconds.", days, hours, minutes, seconds)
  return string.format("%d hours, %d minutes, %d seconds", hours, minutes, seconds)
end

M.volumeUp = function()
  local device = hs.audiodevice.current()
  if device.volume < 100 then
    device.device:setOutputVolume(device.volume + 1)
  end
end

M.volumeDown = function()
  local device = hs.audiodevice.current()
  if device.volume > 0 then
    device.device:setOutputVolume(device.volume - 1)
  end
end

return M
