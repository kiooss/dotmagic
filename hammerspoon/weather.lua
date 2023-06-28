local util = require("util")
local obj = {}

function obj:init(apiKey, city)
  self.urlApi =
    string.format("https://api.weatherapi.com/v1/forecast.json?key=%s&q=%s&days=3&aqi=yes&alerts=yes", apiKey, city)
  self.menubar = hs.menubar.new()
  self.menubar:setTitle("⌛")
  self:getWeather()
  self.timer = hs.timer.doEvery(3600, function()
    self:getWeather()
  end)
end

function obj:updateMenubar(menuData)
  self.menubar:setTooltip("Weather Info")
  self.menubar:setMenu(menuData)
end

function obj:getWeather()
  hs.http.doAsyncRequest(self.urlApi, "GET", nil, nil, function(code, body, htable)
    if code ~= 200 then
      hs.alert.show("get weather error:" .. code)
      return
    end
    local menuData = {}
    local json = hs.json.decode(body)
    local currentData = json.current
    local icon = hs.image.imageFromURL("https:" .. currentData.condition.icon):size({ w = 24, h = 24 })
    self.menubar:setIcon(icon)
    self.menubar:setTitle(json.current.temp_c)
    local titlestr = string.format(
      "现在 🌡️%s°C (体感: %s°C) 💧湿度: %s%% 💨%s kph 🌞紫外线: %s",
      currentData.temp_c,
      currentData.feelslike_c,
      currentData.humidity,
      currentData.wind_kph,
      currentData.uv
    )
    table.insert(menuData, {
      title = titlestr,
      image = hs.image.imageFromURL("https:" .. currentData.condition.icon):size({ w = 40, h = 40 }),
    })
    table.insert(menuData, { title = "-" })

    local forecastData = json.forecast.forecastday
    -- util.d(forecastData)

    for k, v in pairs(forecastData) do
      local menuTitle = string.format(
        "%s 🌡️%s°C ~ %s°C 💧湿度: %s%% ☔️降雨概率: %s%% 🌞紫外线: %s 🌇%s",
        v.date,
        v.day.mintemp_c,
        v.day.maxtemp_c,
        v.day.avghumidity,
        v.day.daily_chance_of_rain,
        v.day.uv,
        v.astro.sunset
      )
      table.insert(menuData, {
        title = menuTitle,
        image = hs.image.imageFromURL("https:" .. v.day.condition.icon):size({ w = 32, h = 32 }),
        menu = obj.buildSubMenu(v.hour),
      })
    end
    table.insert(menuData, { title = "-" })
    table.insert(menuData, { title = "Last updated: " .. os.date("%Y/%m/%d %H:%M:%S") })

    self:updateMenubar(menuData)
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
      "%s 🌡️%s°C (体感: %s°C %s) 💧湿度: %s%% 🌞紫外线: %s %s",
      v.time,
      v.temp_c,
      v.feelslike_c,
      hot,
      v.humidity,
      v.uv,
      will_rain
    )
    local icon = hs.image.imageFromURL("https:" .. v.condition.icon):size({ w = 32, h = 32 })
    table.insert(subMenu, { title = menuTitle, image = icon })
  end

  return subMenu
end

return obj
