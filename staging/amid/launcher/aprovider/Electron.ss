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

  self._appPath = require( 'electron' );

  var launcherPath  = _.pathResolve( __dirname, '../ElectronProcess.ss' );
  launcherPath  = _.fileProvider.pathNativize( launcherPath );

  var port = _.urlParse( self.url ).port;
  self._flags =
  [
    launcherPath,
    `headless : ${self.headless}`,
    `port : ${port}`
  ];

  // self._shellOptions =
  // {
  //   mode : 'spawn',
  //   stdio : 'ignore',
  //   code : self._appPath + ' ' + launcherPath + ' ' + self._flags,
  //   outputPiping : 0,
  //   verbosity : self.verbosity,
  // }

  //!!! _.shell: Consequence gives message on o.child close event?


  if( self._headlessNoFocus )
  self._plistEdit();

  var con = self._shell();
  con.doThen( function()
  {
    if( self._plistChanged )
    self._plistRestore();
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

_.prototypeMake
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
