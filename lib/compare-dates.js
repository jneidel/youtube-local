#! /usr/bin/env node

const lastUpdate = new Date( process.argv[2] );

process.stdin.on( "readable", () => {
  const chunk = process.stdin.read();
  if ( chunk !== null ) {
    const data = JSON.parse( chunk.toString() );

    data.items = data.items.filter( x => compareFilter( x ) );

    process.stdout.write( JSON.stringify( data, null, 2 ) );
  }
} );

function compareFilter( item ) {
  const current = new Date( item.snippet.publishedAt );
  return lastUpdate < current;
}

