#! /usr/bin/env node

const fs = require("fs")
const data = fs.readFileSync("./CHANNELS", {encoding: "utf8"})

const arr = data.split("\n")
  .filter( x => x !== "" )
  .map( x => {
    return x.match( /^(.*?)(?:\s.*)?$/ )[1]
  } )
  .map( x => {
    const letters = x.split("")
    if ( letters[0] !== "U" ) {
      letters.unshift( "U" );
      letters.unshift( "U" );
    } else if ( letters[0] === "U" && letters[1] === "C" ) {
      letters.shift()
      letters.shift()
      letters.unshift( "U" );
      letters.unshift( "U" );
    }

    return letters.join("")
  } )

const str = arr.join( "\n" )

fs.writeFileSync( "./CHANNELS_OUT", str )

