local util = require("util")
local obj = {}

obj.apiBaseUrl = "https://api.weatherapi.com/v1/forecast.json"
obj.currentWeather = nil

function obj:getLocation(fn)
  obj.getLocationTimer = hs.timer.delayed
    .new(1, function()
      local location = hs.location.get()
      if location then
        fn(location)
      else
        hs.alert.show("Get location failed!")
        self.menubar:setTitle("💢Geting location failed")
      end
    end)
    :start()
end

function obj:init(apiKey)
  self.menubar = hs.menubar.new()
  self.menubar:setTitle("⌛Geting location...")
  self:getLocation(function(location)
    local query = string.format("%.4f,%.4f", location.latitude, location.longitude)
    self.urlApi = string.format("%s?key=%s&q=%s&days=3&aqi=yes&alerts=yes", self.apiBaseUrl, apiKey, query)
    -- util.d(self.urlApi)
    self:getWeather()
    self.getWeatherTimer = hs.timer.doEvery(3600, function()
      self:getWeather()
    end)
  end)
end

function obj:updateMenubar(json)
  local menuData = {}
  local currentData = json.current
  local icon = hs.image.imageFromURL("https:" .. currentData.condition.icon):size({ w = 24, h = 24 })

  local title = string.format(
    "现在 🌡️%s°C (体感: %s°C) 💧湿度: %s%% 🪁epa: %s 💨%s kph (%s) 🌞紫外线: %s 📍%s (%s)",
    currentData.temp_c,
    currentData.feelslike_c,
    currentData.humidity,
    currentData.air_quality["us-epa-index"],
    currentData.wind_kph,
    currentData.wind_dir,
    currentData.uv,
    json.location.name .. " " .. json.location.region,
    currentData.condition.text
  )
  util.iMessage(os.date("%Y/%m/%d %H:%M") .. " " .. title)
  table.insert(menuData, {
    title = title,
    image = hs.image.imageFromURL("https:" .. currentData.condition.icon):size({ w = 40, h = 40 }),
  })
  table.insert(menuData, { title = "-" })

  local forecastData = json.forecast.forecastday
  -- util.d(forecastData)

  for k, v in pairs(forecastData) do
    local menuTitle = string.format(
      "%s 🌡️%s°C ~ %s°C 💧湿度: %s%% ☔️降雨概率: %s%% 🌞紫外线: %s 🌇%s %s",
      v.date,
      v.day.mintemp_c,
      v.day.maxtemp_c,
      v.day.avghumidity,
      v.day.daily_chance_of_rain,
      v.day.uv,
      v.astro.sunset,
      v.day.condition.text
    )
    table.insert(menuData, {
      title = menuTitle,
      image = hs.image.imageFromURL("https:" .. v.day.condition.icon):size({ w = 32, h = 32 }),
      menu = obj.buildSubMenu(v.hour),
    })
  end
  table.insert(menuData, { title = "-" })
  table.insert(menuData, {
    title = "Last updated: " .. currentData.last_updated .. " | Last fetch: " .. os.date("%Y/%m/%d %H:%M:%S"),
    disabled = true,
  })

  self.menubar:setIcon(icon)
  self.menubar:setTitle(json.current.temp_c)
  self.menubar:setTooltip(json.current.condition.text)
  self.menubar:setMenu(menuData)
  self.currentWeather = json.current
end

function obj:getWeather()
  self.menubar:setTitle("⌛Geting weather...")
  hs.http.doAsyncRequest(self.urlApi, "GET", nil, nil, function(code, body, _headers)
    if code ~= 200 then
      self.menubar:setTitle("💢Geting weather failed")
      hs.alert.show("get weather error:" .. code)
      return
    end
    self:updateMenubar(hs.json.decode(body))
  end)
end

function obj.buildSubMenu(data)
  local subMenu = {}
  for _, v in pairs(data) do
    local will_rain = ""
    local hot = ""
    if v.feelslike_c > 35 then
      hot = "🔥"
    end
    if v.will_it_rain == 1 then
      will_rain = "☔️"
    end
    local menuTitle = string.format(
      "%s 🌡️%s°C (体感: %s°C %s) 💧%s%% 🌞紫外线: %s %s %s",
      string.sub(v.time, 11),
      v.temp_c,
      v.feelslike_c,
      hot,
      v.humidity,
      v.uv,
      will_rain,
      v.condition.text
    )
    local icon = hs.image.imageFromURL("https:" .. v.condition.icon):size({ w = 32, h = 32 })
    local checked = v.time == os.date("%Y-%m-%d %H:00")
    if checked then
      table.insert(subMenu, { title = "-" })
    end
    table.insert(subMenu, { title = menuTitle, image = icon, checked = checked })
  end

  return subMenu
end

function obj:sayCurrentWeather()
  if not self.currentWeather then
    return
  end
  local msg = string.format(
    "Current weather is %s, feels like %s °C",
    self.currentWeather.condition.text,
    self.currentWeather.feelslike_c
  )
  util.say(msg)
end

return obj
