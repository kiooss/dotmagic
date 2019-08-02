#!/usr/bin/env node

const lib = require("../");
const path = require("path");
const os = require("os");
const fonts = require("weird-fonts");

const configDir = path.join(os.homedir(), "etc");
const forecastIOApiKey = require(path.join(configDir, "forecastio.json")).token;

const getWeather = lib.cacheableRequest("get-weather", lib.getJSON);

function icon(weather) {
  switch (weather.icon) {
    case "clear-day":
      // TODO: add sunrise/sunset 🌇 🌅
      return "☀️";
    case "clear-night":
      return "🌙";
    case "sleet":
      return "🌨";
    case "rain":
      return "☔";
    case "snow":
      return "❄️";
    case "wind":
      return "💨";
    case "fog":
      return "🌁";
    case "cloudy":
      return "☁️";
    case "partly-cloudy-night":
      return "☁️🌛";
    case "partly-cloudy-day":
      return "⛅️";
    default:
      return weather.icon;
  }
}

function temperature(weather) {
  let tempC = weather.temperature;
  let color = 255;
  let tempF = tempC * 1.8 + 32;
  if (tempF < 40) {
    color = 27;
  } else if (tempF < 50) {
    color = 39;
  } else if (tempF < 60) {
    color = 50;
  } else if (tempF < 70) {
    color = 220;
  } else if (tempF < 80) {
    color = 208;
  } else if (tempF < 90) {
    color = 202;
  } else {
    color = 196;
  }
  // return `#[fg=colour${color}]${parseInt((temp - 32) / 1.8)}°C`
  return `#[fg=colour${color}]${tempC}°C`;
}

const latlon = {
  lat: 31.282451,
  lon: 120.573378
};

const apiUrl = `https://api.darksky.net/forecast/${forecastIOApiKey}/${latlon.lat},${latlon.lon}?lang=zh&units=si`;

getWeather(apiUrl)
  .then(res => {
    console.log(`${icon(res.currently)}  ${temperature(res.currently)}`);
  })
  .catch(err => {
    lib.handleError("get-weather", err);
  });
