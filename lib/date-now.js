#! /usr/bin/env node

const date = new Date(); // GMT
date.setHours( date.getHours() + 1 ); // CET
console.log( date.toISOString() );
