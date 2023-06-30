local obj = {}

local function generateHyperMappings(mappings)
  local html = "<h2>Hyper Mappings</h2><table><tr><th>Key</th><th>Desc</th></tr>"

  for _, v in ipairs(mappings) do
    html = html .. string.format("<tr><td>⚡️ %s</td><td>%s</td></tr>", v[1], v[2])
  end

  html = html .. "</table>"

  return html
end

local function generateCmdShiftMappings(mappings)
  local html = "<h2>Cmd Shift Mappings</h2><table><tr><th>Key</th><th>Desc</th></tr>"

  for _, v in ipairs(mappings) do
    html = html .. string.format("<tr><td>⌘⇧ %s</td><td>%s</td></tr>", v[1], v[2])
  end

  html = html .. "</table>"

  return html
end

local function generateAppMappings(mappings)
  local html = "<h2>Lauch App Mappings</h2><table><tr><th>Key</th><th>Desc</th></tr>"

  for _, v in ipairs(mappings) do
    html = html .. string.format("<tr><td>⚡️ %s</td><td>%s</td></tr>", table.unpack(v))
  end

  html = html .. "</table>"

  return html
end

local function generateHtml(mappings)
  local html = [[
<!DOCTYPE html>
<html>
<head>
  <style>
  body {
    background-color: #ECF0F1;
  }
  main {
    display: flex;
  }
  div {
    padding: 0 1em;
  }
  table {
    border-collapse: collapse;
    width: 100%;
  }
  th, td {
    border: 1px solid black;
    padding: 2px 8px;
    text-align: left;
  }
  th {
    background-color: #B2BABB;
  }
  </style>
</head>
<body>
  <main>
    <div>]] .. generateHyperMappings(mappings.hyperMappings) .. [[</div>
    <div>]] .. generateCmdShiftMappings(mappings.cmdShiftMappings) .. [[</div>
    <div>]] .. generateAppMappings(mappings.appMappings) .. [[</div>
  </main>
</body>
</html>
    ]]

  return html
end

function obj:init(mappings)
  self.sheetView = hs.webview.new({ x = 0, y = 0, w = 0, h = 0 })
  self.sheetView:windowTitle("Cheatsheet")
  self.sheetView:windowStyle("utility")
  self.sheetView:allowGestures(true)
  self.sheetView:allowNewWindows(false)
  self.sheetView:level(hs.drawing.windowLevels.modalPanel)
  -- self.sheetView:level(hs.drawing.windowLevels.tornOffMenu)
  local cscreen = hs.screen.mainScreen()
  local cres = cscreen:fullFrame()
  self.sheetView:frame({
    x = cres.x + cres.w * 0.15 / 2,
    y = cres.y + cres.h * 0.25 / 2,
    w = cres.w * 0.85,
    h = cres.h * 0.75,
  })
  local webcontent = generateHtml(mappings)
  self.sheetView:html(webcontent)
end

function obj:show()
  self.sheetView:show()
end

function obj:hide()
  self.sheetView:hide()
end

function obj:toggle()
  if self.sheetView and self.sheetView:hswindow() and self.sheetView:hswindow():isVisible() then
    self:hide()
  else
    self:show()
  end
end

return obj
