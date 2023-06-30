local log = hs.logger.new("💥 debug", "debug")
-- say -v '?'
local speaker = hs.speech.new("Samantha")
local inspect = hs.inspect.inspect
P = hs.inspect.inspect

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

M.execute = function(cmd)
  local output, status = hs.execute(cmd .. " 2>&1")
  if not status then
    local message = string.format("Execute cmd: %s failed.\nOutput: %s", cmd, output)
    hs.alert.show(message)
    M.d(message)
  end
end

M.mark = function(str, window)
  local width = 320
  local height = 230
  local canvas = hs.canvas.new({ x = 100, y = 100, h = 200, w = 200 })
  canvas[1] = {
    type = "text",
    text = str,
    textFont = "Impact",
    textSize = 135,
    textColor = { hex = "#1891C3" },
    textAlignment = "center",
  }
  -- local mainScreen = hs.screen.primaryScreen()
  -- local mainRes = mainScreen:fullFrame()
  local windowFrame = window:frame()
  canvas:frame({
    x = (windowFrame.w - width) / 2,
    y = (windowFrame.h - height) / 2,
    w = width,
    h = height,
  })
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

return M
