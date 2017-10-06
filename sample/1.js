var two = require( './2.js' );
console.log( two );

if( typeof module !== 'undefined' )
module[ 'exports' ] = { one : 1 };