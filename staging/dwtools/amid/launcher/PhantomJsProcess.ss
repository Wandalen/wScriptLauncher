( function _PhantomJsProcess_ss_() {

'use strict';

var page = require( 'webpage' ).create();
var system = require( 'system' );
var fs = require( 'fs' );
var url = system.args[ 1 ];

page.onConsoleMessage = function( msg )
{
  console.log( msg )
};

page.open( url, function ( status )
{
  if( _.routineIs( process.send ) )
  process.send( status );

  phantom.exit()
})

})();
