( function _Chrome_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );
  // var chromeLauncher = require( 'lighthouse/chrome-launcher' );
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

Self.nameShort = 'Chrome';

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
  var profilePath = _.pathResolve( __dirname, '../../../../tmp.tmp/chrome' );
  //!!! later replace this with automatic port finding
  var debuggingPort = 9222;
  //!!! add automatic chrome path finding
  self._appPath = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
  self._flags =
  [
    `--no-first-run`,
    `--no-default-browser-check`,
    // `--no-startup-window`,
    `--disable-component-extensions-with-background-pages`,
    `--disable-infobars`,
    `--disable-gl-drawing-for-tests`,
    `--remote-debugging-port=${ debuggingPort }`,
    `--user-data-dir=${ profilePath }`,
    self.url
  ];

  if( self.headless )
  self._flags.unshift( '--headless', '--disable-gpu' );

  self._flags = self._flags.join( ' ' );

  // self._shellOptions =
  // {
  //   mode : 'shell',
  //   code : chromePath + ' ' + flags,
  //   stdio : 'ignore',
  //   outputPiping : 0,
  //   verbosity : self.verbosity,
  // }

  debugger;
  if( self._headlessNoFocus )
  self._plistEdit();

  self._appPath = _.strReplaceAll( self._appPath,' ', '\\ ' );

  var con = self._shell();

  if( self._plistChanged )
  con.doThen( () => self._plistRestore() );

  return con;
}

//

// function runAct()
// {
//   var self = this;
//
//   var con = new wConsequence();
//
//   var flags = [];
//
//   if( self.headless )
//   flags.push( '--headless', '--disable-gpu' );
//
//   chromeLauncher.launch
//   ({
//     startingUrl: self.url,
//     chromeFlags: flags
//   })
//   .then( function( chrome )
//   {
//     self._shellOptions = chrome;
//     console.log( self._shellOptions.kill );
//     if( self.verbosity >= 3 )
//     logger.log( `Chrome debugging port running on ${chrome.port}` );
//     con.give();
//   })
//   .catch( function ( err )
//   {
//     con.error( err );
//   })
//
//   return con;
// }

//

// function terminateAct()
// {
//   var self = this;
//
//   var con = new wConsequence().give();
//
//   if( !self._shellOptions.child )
//   con.doThen( () => _.err( 'Process is not running' ) );
//   else
//   con.doThen( () => self._shellOptions.child.kill() );
//
//   return con;
// }

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
_.PlatformProvider[ Self.nameShort ] = Self;

if( !_.PlatformProvider.Default )
_.PlatformProvider.Default = Self;

})();
