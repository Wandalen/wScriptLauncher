( function _Chrome_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );
  var chromeLauncher = require( 'lighthouse/chrome-launcher' );
}

var _ = wTools;

//

var Parent = _.PlatformProvider.Abstract;
var Self = function wPlatformProviderChrome( o )
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

  var con = new wConsequence();

  var flags = [];

  if( self.headless )
  flags.push( '--headless', '--disable-gpu' );

  chromeLauncher.launch
  ({
    startingUrl: self.url,
    chromeFlags: flags
  })
  .then( function( chrome )
  {
    self._process = chrome;
    if( self.verbosity >= 3 )
    logger.log( `Chrome debugging port running on ${chrome.port}` );
    con.give();
  })
  .catch( function ( err )
  {
    con.error( err );
  })

  return con;
}

//

function terminateAct()
{
  var self = this;

  var con = new wConsequence();

  if( !self._process )
  con.error( _.err( "Process is not running" ) );
  else
  {
    self._process.kill()
    .then( function()
    {
      con.give();
    })
    .catch( function ( err )
    {
      con.error( err );
    });
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
_.PlatformProvider.Chrome = Self;

if( typeof module !== 'undefined' )
if( !_.PlatformProvider.Default )
{
  _.PlatformProvider.Default = Self;
  // no need to make an instance implicitly
  // _.platformProvider = new Self();
}

})();
