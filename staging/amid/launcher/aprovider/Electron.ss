( function _Electron_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );
}

var _ = wTools;

//

var Parent = _.PlatformProvider.Abstract;
var Self = function wPlatformProviderElectron( o )
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
}

//

function runAct()
{
  var self = this;

  var electron = require( 'electron' );

  var launcherPath  = _.pathResolve( __dirname, '../ElectronLauncher.ss' );

  var port = _.urlParse( self.url ).port;
  var args = `headless : ${self.headless} port : ${port}`;

  var o =
  {
    mode : 'shell',
    stdio : [ null, null, null, 'ipc' ],
    code : electron + ' ' + launcherPath + ' ' + args,
    outputPiping : 0,
    verbosity : 0,
  }

  //!!! _.shell: Consequence gives message on o.child close event?
  var con = _.shell( o );
  o.child.on( 'message', function( msg )
  {
    if( msg === 'ready' )
    con.give();
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

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
}

//

_.protoMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.PlatformProvider.AdvancedMixin.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.PlatformProvider.Electron = Self;

if( typeof module !== 'undefined' )
if( !_.PlatformProvider.Default )
_.PlatformProvider.Default = Self;

})();
