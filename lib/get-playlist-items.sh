#! /bin/bash


if [[ $1 = "--help" ]] || [[ $1 = "help" ]]; then
  echo "$ get-playlist-items.sh <playlist>"
  echo "Download playlist items from yt api,\ncompare the publishing date against 'LAST_UPDATE'\nand add those videos to 'videos'."
  echo ""
  echo "Parameters:"
  echo "$1: playlist to download"
  echo ""
  echo "Example:"
  echo "$ get-playlist-items.sh UU0BAd8tPlDqFvDYBemHcQPQ"
  exit
fi

PLAYLIST=$1
DIR=~/scripts/yt
LIB="$DIR/lib"
API_KEY=$(cat $DIR/env.json | jq .YOUTUBE_API_KEY | $LIB/trim-quotes.js)
PLAYLIST_LEN=$(cat $DIR/env.json | jq .PLAYLIST_LEN)

if [[ $PLAYLIST = "UU0BAd8tPlDqFvDYBemHcQPQ" ]]; then
  PLAYLIST_LEN=15 # playlist order is messed up, with 5 new vids arent in range
fi

DATA=$(curl -s "https://www.googleapis.com/youtube/v3/playlistItems?key=$API_KEY&part=snippet&playlistId=$PLAYLIST&maxResults=$PLAYLIST_LEN")
DATA=$(echo $DATA | $LIB/parse-json.js) # does work if directly chained

LAST_DATE=$(cat $DIR/LAST_UPDATE)
CHANNEL=$(echo $DATA | jq .items[0].snippet.channelTitle | $LIB/trim-quotes.js)
echo "Trying: $CHANNEL"

PLAYLIST_LEN=$(echo $PLAYLIST_LEN-1 | bc) # index starts a 0
for x in $(seq 0 $PLAYLIST_LEN)
  do {
    CURRENT_DATE=$(echo $DATA | jq .items[$x].snippet.publishedAt | $LIB/trim-quotes.js)
    IS_AFTER=$(node $LIB/compare-dates.js $LAST_DATE $CURRENT_DATE )

    if [[ $IS_AFTER == "true" ]]; then
      TITLE=$(echo $DATA | jq .items[$x].snippet.title | $LIB/trim-quotes.js)
      VIDEO_ID=$(echo $DATA | jq .items[$x].snippet.resourceId.videoId | $LIB/trim-quotes.js)
      URL="https://www.youtube.com/watch?v=$VIDEO_ID"
      echo "$CHANNEL: $TITLE - $URL" >> $DIR/videos
      echo "$CHANNEL: $TITLE - $URL"
    fi
  }
done

