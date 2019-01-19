#! /bin/bash

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
CHANNELS=$(cat $DIR/CHANNELS_OUT)
for c in $CHANNELS
  do $LIB/get-playlist-items.sh $c
done

$LIB/date-now.js > $DIR/LAST_UPDATE

