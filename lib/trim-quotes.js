#! /usr/bin/env node

process.stdin.on( "readable", () => {
  const chunk = process.stdin.read();
  if ( chunk !== null ) {
    const data = chunk.toString().replace( /"/g, "" );
    process.stdout.write( data );
  }
} );

