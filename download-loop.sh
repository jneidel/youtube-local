# /bin/bash

if [[ $1 = "--help" ]] || [[ $1 = "help" ]]; then
  echo "$ download-loop.sh"
  echo "Download new videos from playlist in CHANNELS_OUT"
  echo ""
  echo "Example:"
  echo "$ download-loop.sh"
  exit
fi

DIR=~/scripts/yt
LIB="$DIR/lib"
DATA_DIR="$DIR/data"
API_KEY=$(cat $DIR/env.json | jq .YOUTUBE_API_KEY | sed --expression='s/"//g')
PLAYLIST_LEN=$(cat $DIR/env.json | jq .PLAYLIST_LEN)

CHANNELS=$(cat $DATA_DIR/CHANNELS_OUT)
CHANNEL_LEN=$(cat $DATA_DIR/CHANNELS_OUT | wc -l)
CHANNEL_CURRENT=-1

for c in $CHANNELS
  do $LIB/get-playlist-items.sh $c $API_KEY $PLAYLIST_LEN
  # do { <cmd> & } for async, but it doesnt work correctly

  CHANNEL_CURRENT=$(($CHANNEL_CURRENT+1))
  COUNTER=$(cat $DATA_DIR/COUNTER)
  if [[ $COUNTER -gt 0 ]]; then
    echo -ne "Tried $CHANNEL_CURRENT/$CHANNEL_LEN channels - $COUNTER new videos added\r"
  else
    echo -ne "Tried $CHANNEL_CURRENT/$CHANNEL_LEN channels\r"
  fi
done

COUNTER=$(cat $DATA_DIR/COUNTER)
echo "$COUNTER new videos added                              " # without trailing whitespace it won't override "ls - x new videos..."

$LIB/date-now.js > $DATA_DIR/LAST_UPDATE
echo 0 > $DATA_DIR/COUNTER

