hs.alert.defaultStyle.strokeColor = { white = 1, alpha = 0 }
hs.alert.defaultStyle.fillColor = { white = 0.05, alpha = 0.75 }
hs.alert.defaultStyle.radius = 5
hs.alert.defaultStyle.fadeOutDuration = 0.5
hs.alert.defaultStyle.textFont = "Input Mono"

hs.window.animationDuration = 0

-- loglevel - (optional) can be 'nothing', 'error', 'warning', 'info', 'debug', or 'verbose',
-- or a corresponding number between 0 and 5; uses hs.logger.defaultLogLevel if omitted
hs.logger.defaultLogLevel = "warning"
local log = hs.logger.new("💥💥", "debug")
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

M.split = function(input, delimiter)
  input = tostring(input)
  delimiter = tostring(delimiter)
  if delimiter == "" then
    return false
  end
  local pos, arr = 0, {}
  -- for each divider found
  for st, sp in
    function()
      return string.find(input, delimiter, pos, true)
    end
  do
    table.insert(arr, string.sub(input, pos, st - 1))
    pos = sp + 1
  end
  table.insert(arr, string.sub(input, pos))
  return arr
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

return M
