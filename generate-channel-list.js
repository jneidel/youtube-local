#! /usr/bin/env node

const fs = require( "fs" );
const path = require( "path" );
const data = fs.readFileSync( path.resolve( __dirname, "CHANNELS" ), { encoding: "utf8" } );

const arr = data.split( "\n" )
  .filter( x => x !== "" ) // Empty lines
  .filter( x => x[0] !== "#" ) // Comment lines
  .map( x => {
    return x.match( /^(.*?)(?:\s.*)?$/ )[1];
  } )
  .map( x => {
    const letters = x.split( "" );

    if ( letters[0] === "U" && letters[1] === "C" ) {
      letters.shift();
      letters.shift();
      letters.unshift( "U" );
      letters.unshift( "U" );
    }

    return letters.join( "" );
  } );

const str = arr.join( "\n" );

fs.writeFileSync( path.resolve( __dirname, "data", "CHANNELS_OUT" ), str );

console.log( "Wrote data/CHANNELS_OUT" );

