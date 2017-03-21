#!/bin/bash
#
# Weather
# =======
#
# Based on the work of...
# By Jezen Thomas jezen@jezenthomas.com
#
# https://jezenthomas.com/showing-the-weather-in-tmux/

# This script sends a couple of requests over the network to retrieve
# approximate location data, and the current weather for that location. This is
# useful if for example you want to display the current weather in your tmux
# status bar.

# There are three things you will need to do before using this script.
#
# 1. Install jq with your package manager of choice (homebrew, apt-get, etc.)
# 2. Sign up for a free account with forecast.io to grab your API key
# 3. Add your forecast.io API key where it says API_KEY

# Limit the rate of calls to every 2 minutes
MINUTE=$(date +"%M")
if [ $((MINUTE%5)) -ne 2 ]; then
WEATHER_STATUS="cat ~/Dropbox/code/weather.txt"
echo $WEATHER_STATUS
exit
fi

API_KEY=SO_SEKRIT_YALL

set -e

# https://darksky.net/dev/docs/response#data-point
weather_icon() {
case $1 in
clear-day) echo
;;
clear-night) echo
;;
rain) echo ☔️
;;
snow) echo ❄️
;;
sleet|hail) echo
;;
wind) echo
;;
fog) echo
;;
cloudy) echo ☁️
;;
partly-cloudy-day) echo
;;
partly-cloudy-night) echo ☁︎
;;
thunderstorm) echo
;;
tornado) echo
;;
*) echo  $1
esac
}

LOCATION=$(curl --silent http://ip-api.com/csv)
CITY=$(echo "$LOCATION" | cut -d , -f 6)
LAT=$(echo "$LOCATION" | cut -d , -f 8)
LON=$(echo "$LOCATION" | cut -d , -f 9)

URL="https://api.darksky.net/forecast/$API_KEY/$LAT,$LON?exclude=hourly,minutely,daily,alerts,flags"
WEATHER=$(curl --silent $URL)

SUMMARY=$(echo "$WEATHER" | jq .currently.summary | sed s/\"//g)
ICON=$(echo "$WEATHER" | jq .currently.icon | sed s/\"//g)
TEMP="$(echo "$WEATHER" | jq .currently.temperature | xargs printf "%.f\n" 0)°F"
WIND_SPEED="$(echo "$WEATHER" | jq .currently.windSpeed | xargs printf "%.f" 0) MPH"
EMOJI=$(weather_icon $ICON)

WEATHER_STATUS="$CITY:$EMOJI $SUMMARY $TEMP, $WIND_SPEED"
# echo $WEATHER_STATUS > ~/Dropbox/code/weather.txt
echo $WEATHER_STATUS


