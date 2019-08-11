( function _Abstract_s_() {

'use strict';

if( typeof module !== 'undefined' )
{
}

//

var _ = wTools;
var Parent = null;
var Self = function wPlatformProviderAbstract( o )
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

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( self.verbosity > 1 )
  logger.log( 'new',_.strTypeOf( self ) );

  self._headlessNoFocus = process.platform === 'darwin' && self.headless && self.allowPlistEdit;

}

//

function run()
{
  var self = this;

  // process.on( 'SIGINT', function()
  // {
  //   if( self._plistChanged )
  //   self._plistRestore();
  // });

  return self.runAct();
}

//

function terminate()
{
  var self = this;
  return self.terminateAct();
}

//

function terminateAct()
{
  var self = this;

  var con = new _.Consequence().take( null );

  con.then( () => 
  { 
    self._shellOptions.process.kill( 'SIGINT' );
    return null; 
  });

  if( self._headlessNoFocus )
  con.then( () => self._plistRestore() );

  if( self._xvfbDisplayPid )
  con.then( () => self._xvfbDisplayKill() );

  return con;
}

//

function _shell()
{
  var self = this;
  var code;

  if( !self._shellOptions )
  {
    // if( self.usingOsxOpen )
    // {
    //   if( !self.osxOpenOptions )
    //   self.osxOpenOptions = '-W -n -j -g -a';
    //
    //   code = 'open ' + self.osxOpenOptions + ' ' + self._appPath + ' --args ' + self._flags
    // }
    // else
    // {
    //   code = self._appPath + ' ' + self._flags.join( ' ' );
    // }

    debugger
    self._appPath = _.fileProvider.path.nativize( self._appPath );

    self._shellOptions =
    {
      mode : 'spawn',
      execPath : self._appPath,
      args : self._flags,
      stdio : 'pipe',
      outputPiping : 1,
      verbosity : self.verbosity,
    }
  }

  debugger
  return _.shell( self._shellOptions )
  .then( function ()
  {
    self._shellOptions.process.on( 'close', function ()
    {
      self._plistRestore();
    })
    return null;
  })
}

// --
// relationship
// --

var Composes =
{
  url : null,
  headless : true,
  verbosity : 1,
  osxOpenOptions : null,
  usingOsxOpen : 0,
  allowPlistEdit : 1,
  debug : 0
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
  _shellOptions : null,
  _plistPath : null,
  _appPath : null,
  _flags : null,
  _plistChanged : false,
  _headlessNoFocus : false,
  _xvfbDisplayPid : null
}

var Statics =
{
}

// --
// prototype
// --

var Proto =
{

  init : init,

  //

  run : run,

  terminate : terminate,
  terminateAct : terminateAct,

  _shell : _shell,

  // relationships

  //constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

wCopyable.mixin( Self );

//

_.PlatformProvider = _.PlatformProvider || Object.create( null );
_.PlatformProvider.Abstract = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
