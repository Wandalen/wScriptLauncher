(function _Tools_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  var getPort = require( 'get-port' );
}

var _ = wTools;
var Self = wTools;

function portGet()
{
  _.assert( arguments.length <= 1 );

  var con = new wConsequence();
  getPort.apply( this, arguments )
  .then( port => con.give( port ) );
  return con;
}

//

var Proto =
{
  portGet : portGet
}

_.mapExtend( Self,Proto );


if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = Self;
}

})();
