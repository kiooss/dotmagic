local util = require("util")
local obj = {}

obj.config = {
  databasePath = os.getenv("HOME") .. "/.cache/clipboard.sqlite3",
  queryPage = 0,
  pageSize = 9,
}

function obj:db()
  return hs.sqlite3.open(self.config.databasePath)
end

function obj:init()
  self:initDatabase()

  self.pasteboardWatcher = hs.pasteboard.watcher.new(function(v)
    self:storeText(v)
  end)
  self.pasteboardWatcher:start()

  self.chooser = hs.chooser.new(function(choice)
    if choice then
      hs.pasteboard.setContents(choice.raw)
      hs.eventtap.keyStroke({ "cmd" }, "v")
    end
  end)
  self.chooser:placeholderText("Search clipboard history")

  self.actionChooser = hs.chooser.new(function(choice)
    if choice then
      if choice.action == "clear" then
        self:clearHistory()
      end
    end
  end)
  self.actionChooser:placeholderText("Clipboard history action")
  self.actionChooser:choices({
    { text = "Clear all histories", action = "clear" },
  })
end

function obj:show()
  self.chooser:query(nil)
  self.chooser:choices(self:getChoices())
  self.chooser:show()
end

function obj:showActionChooser()
  self.actionChooser:show()
end

function obj:initDatabase()
  local displayName = hs.fs.displayName(self.config.databasePath)
  if displayName == nil then
    local tableHistory = [[
    CREATE TABLE IF NOT EXISTS history (
      id INTEGER PRIMARY KEY,
      text TEXT UNIQUE,
      app_bundle_id TEXT,
      copy_count INTEGER DEFAULT 0,
      paste_count INTEGER DEFAULT 0,
      last_pasted_at INTEGER,
      last_copied_at INTEGER,
      created_at INTEGER
    );
]]
    local db = self:db()
    db:exec(tableHistory)
    db:close()
  end
end

function obj:clearHistory()
  local db = self:db()
  local sql = "DELETE FROM history"
  if db:exec(sql) == hs.sqlite3.OK then
    hs.alert.show("All clipboard history deleted!")
  end
  db:close()
end

function obj:incrementText(text)
  local exists = false
  local db = self:db()
  local sql = "update history set copy_count = copy_count + 1, last_copied_at = strftime('%s', 'now') where text = ?"
  local stmt = db:prepare(sql)
  stmt:bind_values(text)

  -- Check the result
  if stmt:step() == hs.sqlite3.DONE then
    if db:changes() ~= 0 then
      exists = true
    end
  else
    hs.alert.show("Update clipboard database failed!")
  end

  stmt:finalize()
  db:close()

  return exists
end

function obj:storeText(text)
  if text == nil then
    local image = hs.pasteboard.readImage()
    print(image)
    return
  end

  if string.match(text, "^data:image/") then
    -- base64 的图片
    return
  end

  -- hs.console.printStyledtext(hs.pasteboard.readStyledText())

  if string.len(string.gsub(text, "[ \r\n]+", "")) == 0 then
    -- util.d("Empty text!")
    return
  end

  if self:incrementText(text) == true then
    -- util.d("Already exists: " .. text)
    return
  end

  local appBundleId = util.getFocusedBundleId()
  -- util.d(string.format("General Pasteboard Contents: %s, From: %s", text, appBundleId))

  local db = self:db()
  local sql =
    "INSERT INTO history(text, app_bundle_id, copy_count, last_copied_at, created_at) VALUES(?, ?, 1, strftime('%s', 'now'), strftime('%s', 'now'))"
  local stmt = db:prepare(sql)
  stmt:bind_values(text, appBundleId)

  if not stmt:step() == hs.sqlite3.DONE then
    hs.alert.show("Insert clipboard database failed!")
  end

  stmt:finalize()
  db:close()
end

function obj:getChoices()
  local db = self:db()
  local sql = "select * from history order by last_copied_at desc limit 100"
  local stmt = db:prepare(sql)
  stmt:bind_values()

  local choices = {}
  local index = 1
  for row in stmt:nrows() do
    local text = string.gsub(row.text, "[\r\n]", "⏎")
    text = string.gsub(text, "^[ ]+", "")
    text = string.sub(text, 1, 110)
    local subText =
      string.format("From: %s Copy count: %d Length: %d", row.app_bundle_id, row.copy_count, string.len(row.text))
    choices[index] = {
      ["text"] = text,
      ["subText"] = subText,
      ["raw"] = row.text,
      ["id"] = row.id,
    }
    index = index + 1
  end

  stmt:finalize()
  db:close()

  return choices
end

return obj
