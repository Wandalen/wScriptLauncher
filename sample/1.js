var two = require( './2.js' );
console.log( 'two',two );

if( typeof module !== 'undefined' )
module[ 'exports' ] = { one : 1 };
