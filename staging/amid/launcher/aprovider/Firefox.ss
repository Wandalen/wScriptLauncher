( function _Firefox_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );
}

var _ = wTools;

//

var Parent = _.PlatformProvider.Abstract;
var Self = function wPlatformProviderFirefox( o )
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

  self._appPath = require( 'firefox-location' );
}

//

function runAct()
{
  var self = this;

  var profilePath = _.pathResolve( __dirname, '../../../../tmp.tmp/firefox' );

  self._flags =
  [
    self.url,
    '-no-remote',
    '-profile',
    profilePath
  ]
  .join( ' ' );

  _.fileProvider.directoryMake( profilePath );

  // self._shellOptions =
  // {
  //   mode : 'spawn',
  //   code : firefoxPath + ' ' + args,
  //   outputPiping : 0,
  //   verbosity : 0
  // }


  if( self._headlessNoFocus )
  self._plistEdit();

  var con = self._shell();

  if( self._plistChanged )
  con.doThen( () => self._plistRestore() );

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
_.PlatformProvider.Firefox = Self;

if( typeof module !== 'undefined' )
if( !_.PlatformProvider.Default )
{
  _.PlatformProvider.Default = Self;
  // no need to make an instance implicitly
  // _.platformProvider = new Self();
}

})();
