#! /bin/bash

if [[ $1 = "--help" ]] || [[ $1 = "help" ]]; then
  echo "$ add-video.sh <yt-link>"
  echo "Add a video to videos"
  echo ""
  echo "Parameters:"
  echo "\$1: yt-link"
  echo ""
  echo "Example:"
  echo "$ add-video.sh https://www.youtube.com/watch?v=G_4Cv-AP7xU"
  exit
fi

URL=$1
URL=$( echo $URL | cut -d "&" -f 1)
DIR=~/scripts/yt
LIB="$DIR/lib"
DATA_DIR="$DIR/data"
API_KEY=$(cat $DIR/env.json | jq .YOUTUBE_API_KEY | sed --expression='s/"//g')
VIDEO_ID=$(echo $URL | cut -d "=" -f 2)

DATA=$(curl -s "https://www.googleapis.com/youtube/v3/videos?key=$API_KEY&part=snippet&id=$VIDEO_ID")
DATA=$(echo $DATA | $LIB/parse-json.js)

CHANNEL=$(echo $DATA | jq .items[0].snippet.channelTitle | sed --expression='s/"//g')
TITLE=$(echo $DATA | jq .items[0].snippet.title | sed --expression='s/"//g')
echo "$CHANNEL: $TITLE $URL" >> $DIR/videos

