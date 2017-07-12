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

  process.on( 'SIGINT', function()
  {
    if( self._plistChanged )
    self._plistRestore();

    process.exit();
  });
}

//

function run()
{
  var self = this;

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

  var con = new wConsequence();

  if( self._shellOptions.child.killed )
  con.error( _.err( "Process is not running" ) );
  else
  {
    try
    {
      self._shellOptions.child.kill( 'SIGINT' )
      con.give();
    }
    catch( err )
    {
      con.error( err );
    }
  }

  return con;
}

//

function _plistPathGet()
{
  var self = this;

  var ins = 'Contents';
  var fileName = 'Info.plist';
  var index = self._appPath.indexOf( ins );
  if( index !== -1 )
  {
    self._plistPath = _.pathJoin( self._appPath.slice( 0, index + ins.length ), fileName );
  }
}

//

function _plistEdit()
{
  var self = this;

  self._plistPathGet();

  if( !_.strIs( self._plistPath ) )
  return;

  var plist = require('plist');
  self._plistBackupPath = self._plistPath + '.backup';

  if( !_.fileProvider.fileStat( self._plistBackupPath ) )
  _.fileProvider.fileCopy( self._plistBackupPath, self._plistPath );

  var raw = _.fileProvider.fileRead( self._plistPath );
  var list = plist.parse( raw );
  list.LSBackgroundOnly = true;
  raw = plist.build( list );

  _.fileProvider.fileWrite( self._plistPath, raw );

  self._plistChanged = true;
}

//

function _plistRestore()
{
  var self = this;

  if( _.fileProvider.fileStat( self._plistBackupPath ) )
  {
    _.fileProvider.fileCopy( self._plistPath, self._plistBackupPath );
    _.fileProvider.fileDelete( self._plistBackupPath );
    self._plistChanged = false;
  }
}

//

function _shell()
{
  var self = this;
  var code;

  if( !self._shellOptions )
  {
    if( self.usingOsxOpen )
    {
      if( !self.osxOpenOptions )
      self.osxOpenOptions = '-W -n -j -g -a';

      code = 'open ' + self.osxOpenOptions + ' ' + self._appPath + ' --args ' + self._flags
    }
    else
    {
      code = self._appPath + ' ' + self._flags;
    }

    self._shellOptions =
    {
      mode : 'shell',
      code : code,
      stdio : 'ignore',
      outputPiping : 0,
      verbosity : self.verbosity,
    }
  }

  return _.shell( self._shellOptions )
  .doThen( function ()
  {
    self._shellOptions.child.on( 'close', function ()
    {
      if( self._plistChanged )
      self._plistRestore();
    })
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
  allowPlistEdit : 1
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
  _plistBackupPath : null,
  _appPath : null,
  _flags : null,
  _plistChanged : false,
  _headlessNoFocus : false,
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
  _plistPathGet : _plistPathGet,
  _plistEdit : _plistEdit,
  _plistRestore : _plistRestore,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

_.protoMake
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
{
  module[ 'exports' ] = Self;
}

})();
