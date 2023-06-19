local M = {}

local margin = 6

M.addMargin = function(frame)
  frame.x = frame.x + margin
  frame.y = frame.y + margin
  frame.w = frame.w - (margin * 2)
  frame.h = frame.h - (margin * 2)

  return frame
end

M.leftHalf = function(winFrame, screenFrame)
  winFrame.x = screenFrame.x + margin
  winFrame.y = screenFrame.y + margin
  winFrame.w = screenFrame.w / 2 - margin * 1.5
  winFrame.h = screenFrame.h - margin * 2
  return winFrame
end

M.rightHalf = function(winFrame, screenFrame)
  winFrame.x = screenFrame.x + screenFrame.w / 2 + margin * 0.5
  winFrame.y = screenFrame.y + margin
  winFrame.w = screenFrame.w / 2 - margin * 1.5
  winFrame.h = screenFrame.h - margin * 2
  return winFrame
end

M.topHalf = function(winFrame, screenFrame)
  winFrame.x = screenFrame.x
  winFrame.y = screenFrame.y
  winFrame.w = screenFrame.w
  winFrame.h = screenFrame.h / 2
  return winFrame
end

M.bottomHalf = function(winFrame, screenFrame)
  winFrame.x = screenFrame.x
  winFrame.y = screenFrame.y + screenFrame.h / 2
  winFrame.w = screenFrame.w
  winFrame.h = screenFrame.h / 2
  return winFrame
end

return M
