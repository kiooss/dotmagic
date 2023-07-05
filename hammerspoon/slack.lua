local obj = {}
local util = require("util")

obj.baseUrl = "https://slack.com/api"

function obj:init(token)
  self.token = token
end

function obj:users_getPresence(uid, fn)
  util.d("call slack api: users_getPresence")
  local url = self.baseUrl .. "/users.getPresence?user=" .. uid
  local headers = {
    Authorization = "Bearer " .. self.token,
  }
  hs.http.asyncGet(url, headers, function(code, body, headers)
    if code ~= 200 then
      hs.alert.show("slack: users_getPresence failed!")
    else
      local response = hs.json.decode(body)
      if response.ok then
        fn(response)
      else
        hs.alert.show("slack: users_getPresence failed, reason: " .. response.error)
      end
    end
  end)
end

function obj:chat_postMessage(channel, message)
  util.d("call slack api: chat_postMessage")
  local url = self.baseUrl .. "/chat.postMessage"
  local data = hs.json.encode({
    channel = channel,
    text = message,
  })
  local headers = {
    ["Content-type"] = "application/json",
    Authorization = "Bearer " .. self.token,
  }
  hs.http.asyncPost(url, data, headers, function(code, body, headers)
    if code ~= 200 then
      hs.alert.show("slack: chat_postMessage failed!")
    end
  end)
end

return obj
