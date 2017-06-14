

if( typeof module !== 'undefined' )
{
  var browserify = require('browserify');
  var browser = require( 'browser-run' );
}

/**/

var filePath = __dirname + '/hellomain.js';
browserify( filePath ).bundle().pipe( browser() ).pipe( process.stdout );
