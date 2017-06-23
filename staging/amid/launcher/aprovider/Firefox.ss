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
}

//

function runAct()
{
  var self = this;

  var firefoxPath = require( 'firefox-location' );
  var profilePath = _.pathResolve( __dirname, '../../../../tmp.tmp/firefox' );
  var args =
  [
    self.url,
    '-no-remote',
    '-profile',
    profilePath
  ]
  .join( ' ' );

  _.fileProvider.directoryMake( profilePath );

  self._process =
  {
    mode : 'spawn',
    code : firefoxPath + ' ' + args,
    outputPiping : 0,
    verbosity : 0
  }

  return _.shell( self._process );
}

//

function terminateAct()
{
  var self = this;

  var con = new wConsequence();

  if( self._process.child.killed )
  con.error( _.err( "Process is not running" ) );
  else
  {
    try
    {
      self._process.child.kill( 'SIGINT' )
      con.give();
    }
    catch( err )
    {
      con.error( err );
    }
  }

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
  terminateAct : terminateAct,

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
_.PlatformProvider.Default = Self;

})();
