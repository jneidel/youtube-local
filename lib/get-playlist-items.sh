#! /bin/bash

if [[ $1 = "--help" ]] || [[ $1 = "help" ]]; then
  echo "$ get-playlist-items.sh <playlist>"
  echo "Download playlist items from yt api,\ncompare the publishing date against 'LAST_UPDATE'\nand add those videos to 'videos'."
  echo ""
  echo "Parameters:"
  echo "$1: playlist to download"
  echo "$2: youtube api key"
  echo "$3: length of each playlist"
  echo ""
  echo "Example:"
  echo "$ get-playlist-items.sh UU0BAd8tPlDqFvDYBemHcQPQ"
  exit
fi

PLAYLIST=$1
API_KEY=$2
PLAYLIST_LEN=$3
DIR=~/scripts/yt
LIB="$DIR/lib"
LAST_DATE=$(cat $DIR/LAST_UPDATE)

if [[ $PLAYLIST = "UU0BAd8tPlDqFvDYBemHcQPQ" ]]; then
  PLAYLIST_LEN=15 # playlist order is messed up, with 5 new vids arent in range
fi

DATA=$(curl -s "https://www.googleapis.com/youtube/v3/playlistItems?key=$API_KEY&part=snippet&playlistId=$PLAYLIST&maxResults=$PLAYLIST_LEN")
DATA=$(echo $DATA | $LIB/compare-dates.js $LAST_DATE) # does work if directly chained

TEST=$(echo $DATA | jq .items[].length) # .length does not exist, but returns null for every item, seperated by \n, ideal for 'wc -l' :)

if [[ -n $TEST ]]; then
  LENGTH=$(echo $DATA | jq .items[].length | wc -l) # reusing $TEST does not work (messes up format)
  SEQ_LENGTH=$(echo $LENGTH-1 | bc)
  CHANNEL=$(echo $DATA | jq .items[0].snippet.channelTitle | sed --expression='s/"//g')

  for x in $(seq 0 $SEQ_LENGTH)
    do {
      TITLE=$(echo $DATA | jq .items[$x].snippet.title | sed --expression='s/"//g')
      VIDEO_ID=$(echo $DATA | jq .items[$x].snippet.resourceId.videoId | sed --expression='s/"//g')
      URL="https://www.youtube.com/watch?v=$VIDEO_ID"
      echo "$CHANNEL: $TITLE - $URL" >> $DIR/videos
      #echo "$CHANNEL: $TITLE - $URL"
    }
  done

  COUNTER=$(cat $DIR/COUNTER)
  echo $COUNTER+$LENGTH | bc > $DIR/COUNTER
fi


