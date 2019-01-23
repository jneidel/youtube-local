#! /bin/bash

mkdir ./data;
./lib/date-now.js > ./data/LAST_UPDATE
echo 0 > ./data/COUNTER
./generate-channel-list.js

if [[ -z $(command -v jq) ]]; then
  echo "'Missing dependency: jq' is not installed on your system."
  echo "Github: https://github.com/stedolan/jq"
  echo "Try install it with your package manager, eg: 'pacman -Ss jq'"
  exit
fi

if [[ -e ./env.json ]]; then
  YT_API_KEY=$(cat ./env.json | jq .YOUTUBE_API_KEY)

  if [[ -z $YT_API_KEY ]]; then
    echo "Please add a youtube api key to your 'env.json'."
  fi
else
  echo "Please create a 'env.json' file. And add your youtube api key."
fi

if [[ -e ./CHANNELS ]]; then
  if [[ -z $(cat ./CHANNELS) ]]; then
    echo "Please add your subscribed channels to 'CHANNELS'"
  fi
else
  echo "Please add your subscribed channels to 'CHANNELS'"
  echo "" > ./CHANNELS
fi



