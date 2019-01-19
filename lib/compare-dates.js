#! /usr/bin/env node

/*
 * Is $1 before $2 / Is $2 after $1
 */

const lastDate = process.argv[2];
const currentDate = process.argv[3];

const last = new Date( lastDate );
const current = new Date( currentDate );

console.log( last < current );

