local util = require("util")
local obj = {}

obj.apiBaseUrl = "https://api.weatherapi.com/v1/forecast.json"
obj.currentWeather = nil
obj.chanceOfRainNextHour = nil

local function styledText(text)
  return hs.styledtext.new(text, {
    font = {
      name = "Input Mono",
      size = 12.0,
    },
  })
end

local function styledTextImpact(text, colorHex)
  return hs.styledtext.new(text, {
    font = {
      name = "Impact",
    },
    color = { hex = colorHex },
  })
end

local function epaColor(index)
  local dict = {
    "#68E143",
    "#FFFF54",
    "#EF8532",
    "#EA3323",
    "#854493",
    "#731425",
  }

  return dict[index]
end

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
    util.d(self.urlApi)
    self:getWeather()
    self.getWeatherTimer = hs.timer.doEvery(3600, function()
      self:getWeather()
    end)
  end)
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

function obj:updateMenubar(json)
  local menuData = {}
  local currentData = json.current
  local icon = hs.image.imageFromURL("https:" .. currentData.condition.icon):size({ w = 24, h = 24 })
  local epa = currentData.air_quality["us-epa-index"]

  local title = string.format(
    "现在 🌡️%s°C (%s°C) 💧 %s%% 🌸 %s 💨 %s kph (%s) 🏖️ %s \n📍%s (%s)",
    currentData.temp_c,
    currentData.feelslike_c,
    currentData.humidity,
    epa,
    currentData.wind_kph,
    currentData.wind_dir,
    currentData.uv,
    json.location.name .. " " .. json.location.region,
    currentData.condition.text
  )
  -- util.sendSlackMessage(os.date("%Y/%m/%d %H:%M") .. " " .. title)
  table.insert(menuData, {
    title = styledText(title),
    image = hs.image.imageFromURL("https:" .. currentData.condition.icon):size({ w = 40, h = 40 }),
  })
  table.insert(menuData, { title = "-" })

  local forecastData = json.forecast.forecastday
  -- util.d(forecastData)

  for k, v in pairs(forecastData) do
    local menuTitle = string.format(
      "%s 🌡️%s°C ~ %s°C 💧 %s%% ☔️ %2s%% 🏖️ %s 🌇 %s",
      v.date,
      v.day.mintemp_c,
      v.day.maxtemp_c,
      v.day.avghumidity,
      v.day.daily_chance_of_rain,
      v.day.uv,
      v.astro.sunset
    )
    table.insert(menuData, {
      title = styledText(menuTitle) .. "\n" .. styledText(v.day.condition.text),
      image = hs.image.imageFromURL("https:" .. v.day.condition.icon):size({ w = 32, h = 32 }),
      menu = self:buildSubMenu(v.hour),
    })
  end
  table.insert(menuData, { title = "-" })
  table.insert(menuData, {
    title = "Last updated: " .. currentData.last_updated .. " | Last fetch: " .. os.date("%Y/%m/%d %H:%M:%S"),
    disabled = true,
  })

  self.menubar:setIcon(icon)
  local colorHex = "#0096FA"
  if json.current.feelslike_c > 35 then
    colorHex = "#EC1F0A"
  end

  local styledTitle = styledTextImpact(currentData.temp_c, "#0AECD1")
  styledTitle = styledTitle .. styledTextImpact(" " .. currentData.feelslike_c, colorHex)
  styledTitle = styledTitle .. styledTextImpact("  " .. epa, epaColor(epa))

  if self.chanceOfRainNextHour then
    styledTitle = styledTitle .. styledTextImpact("  " .. self.chanceOfRainNextHour .. "%", "#16A8EC")
  end

  self.menubar:setTitle(styledTitle)
  self.menubar:setTooltip(json.current.condition.text)
  self.menubar:setMenu(menuData)
  self.currentWeather = json.current
end

function obj:buildSubMenu(data)
  local subMenu = {}
  local currentHourIndex = nil
  for i, v in pairs(data) do
    if currentHourIndex and i == currentHourIndex + 1 then
      -- check will_rain
      if v.chance_of_rain >= 70 then
        util.say("It's going to rain for the next hour")
        self.chanceOfRainNextHour = v.chance_of_rain
      else
        self.chanceOfRainNextHour = false
      end
    end
    local will_rain = "☀️"
    local hot = ""
    if v.feelslike_c > 35 then
      hot = " 🔥"
    end
    if v.will_it_rain == 1 then
      will_rain = "☔️"
    end
    local menuTitle = string.format(
      "%s %s %2s%% 🌡️ %s°C (%s°C%s) 💧%s%% 🏖️ %s %s",
      string.sub(v.time, 11),
      will_rain,
      v.chance_of_rain,
      v.temp_c,
      v.feelslike_c,
      hot,
      v.humidity,
      v.uv,
      v.condition.text
    )
    local icon = hs.image.imageFromURL("https:" .. v.condition.icon):size({ w = 32, h = 32 })
    local currentHour = v.time == os.date("%Y-%m-%d %H:00")
    if currentHour then
      table.insert(subMenu, { title = "-" })
      currentHourIndex = i
    end
    table.insert(subMenu, { title = styledText(menuTitle), image = icon })
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
