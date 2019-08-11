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
  var debuggingPort = 9223;

  function _runAct()
  {
    var con = new _.Consequence();
    var profilePath = _.path.resolve( __dirname, '../../../../tmp.tmp/chrome' );
    profilePath = _.fileProvider.path.nativize( profilePath );
    //!!! add automatic chrome path finding
    var finder = require( 'chrome-launcher/dist/chrome-finder' );
    var chromePaths = finder[ process.platform ]();
    self._appPath = chromePaths[ 0 ];
    // self._appPath = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
    self._flags =
    [
      '--no-first-run',
      '--no-default-browser-check',
      // `--no-startup-window`,
      '--disable-component-extensions-with-background-pages',
      '--disable-infobars',
      `--remote-debugging-port=${ debuggingPort }`,
      `--user-data-dir=${ profilePath }`,
      self.url
    ];

    if( process.platform != 'win32' )
    self._flags.push( '--disable-gl-drawing-for-tests' );

    if( !self.headless && self.debug )
    {
      self._flags.push( '--debug-brk', '--auto-open-devtools-for-tabs' );
    }

    if( self.headless )
    {
      var headlessFlags =
      [
        '--headless',
        '--disable-gpu',
        `--window-position=-9999,0`,
        `--window-size=0,0`
      ]
    }
    self._flags.unshift.apply( self._flags, headlessFlags );

    //self._flags = self._flags.join( ' ' );

    // self._shellOptions =
    // {
    //   mode : 'spawn',
    //   code : self._appPath + ' ' + self._flags,
    //   stdio : 'ignore',
    //   outputPiping : 0,
    //   verbosity : self.verbosity,
    // }

    debugger;
    if( self._headlessNoFocus )
    self._plistEdit();

    //self._appPath = _.strReplaceAll( self._appPath,' ', '\\ ' );

    var con = self._shell();

    con.then( function()
    {
      if( self._plistChanged )
      self._plistRestore();
      return null;
    });

    return con;
  }

  return _.portGet( debuggingPort )
  .then( ( port ) => 
  { 
    debuggingPort = port;
    return null;
  })
  .then( () => _runAct() );
}

//

// function runAct()
// {
//   var self = this;
//
//   var con = new _.Consequence();
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
//     con.take( null );
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
//   var con = new _.Consequence().take( null );
//
//   if( !self._shellOptions.process )
//   con.then( () => _.err( 'Process is not running' ) );
//   else
//   con.then( () => self._shellOptions.process.kill() );
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
_.PlatformProvider[ Self.nameShort ] = Self;

if( !_.PlatformProvider.Default )
_.PlatformProvider.Default = Self;

})();
