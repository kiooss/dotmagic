local obj = {}

local function Chinese()
  hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

local function English()
  hs.keycodes.currentSourceID("com.apple.keylayout.US")
end

local function Japanese()
  hs.keycodes.currentSourceID("com.google.inputmethod.Japanese.base")
end

local function set_app_input_method(app_name, set_input_method_function, event)
  event = event or hs.window.filter.windowFocused
  local windowFilter = hs.window.filter.new(app_name)

  windowFilter:subscribe(event, function()
    set_input_method_function()
  end)
end

function obj:init()
  set_app_input_method("Slack", Japanese)
  set_app_input_method("kitty", English)
  -- set_app_input_method("Google Chrome", English)
  set_app_input_method("微信", Chinese)
  -- set_app_input_method("Telegram", English)
end

return obj
