

if( typeof module !== 'undefined' )
{
  require( 'wTools' );
  require( 'wFiles' );
  var run = require( 'browser-run' );
}

var _ = wTools;

/**/

var browser = run();
browser.pipe( process.stdout );
var script = _.fileProvider.fileRead( __dirname + '/helloworld.js' );
browser.end( script );
