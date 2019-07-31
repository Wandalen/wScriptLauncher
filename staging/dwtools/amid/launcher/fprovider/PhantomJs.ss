( function _PhantomJs_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );
}

var _ = wTools;

/* ES6 compatibility problem, will be fixed in version 2.5 */

var Parent = _.PlatformProvider.Abstract;
var Self = function wPlatformProviderPhantomJs( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );

  self._appPath = '';
}

//

function runAct()
{
  var self = this;

  var launcherPath  = _.path.resolve( __dirname, '../PhantomJsProcess.ss' );

  self._flags =
  [
    launcherPath,
    self.url
  ]
  .join( ' ' );

  self._shellOptions =
  {
    mode : 'shell',
    stdio : [ 'inherit', 'inherit', 'inherit', 'ipc' ],
    path : self._appPath + ' ' + self._flags,
    outputPiping : 1,
    verbosity : self.verbosity,
  }

  // if( self._headlessNoFocus )
  // self._plistEdit();

  var con = self._shell();
  con.got( function()
  {
    // if( self._plistChanged )
    // self._plistRestore();

    self._shellOptions.process.on( 'message', function( msg )
    {
      if( msg === 'ready' )
      con.take( null );
    });
 });

  return con;
}

// --
// relationship
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
}

// --
// prototype
// --

var Proto =
{

  init : init,

  runAct : runAct,

  //

  //constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.PlatformProviderMixin.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.PlatformProvider.PhantomJs = Self;

if( typeof module !== 'undefined' )
if( !_.PlatformProvider.Default )
{
  _.PlatformProvider.Default = Self;
}

})();
