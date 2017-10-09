var one = require( './1.js' );
console.log( one );

if( typeof module !== 'undefined' )
module[ 'exports' ] = { two : 2 };