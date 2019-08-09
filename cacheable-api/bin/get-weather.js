#!/usr/bin/env node

const lib = require("../");
const path = require("path");
const os = require("os");
const fonts = require("weird-fonts");

const configDir = path.join(os.homedir(), "etc");
const forecastIOApiKey = require(path.join(configDir, "forecastio.json")).token;

const getWeather = lib.cacheableRequest("get-weather", lib.getJSON, 5);

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
  const tempC = weather.temperature;
  const apparentTemperature = weather.apparentTemperature;
  const tempF = tempC * 1.8 + 32;

  let color = 255;
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

  let face = "☺️";
  if (apparentTemperature > 40) {
    face = "🥵";
  } else if (apparentTemperature > 30) {
    face = "😳";
  } else if (apparentTemperature < 0) {
    face = "🥶";
  }
  // return `#[fg=colour${color}]${parseInt((temp - 32) / 1.8)}°C`
  return `#[fg=colour${color}]${tempC}°C ${face}  ${apparentTemperature}°C`;
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
