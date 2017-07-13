( function _AdvancedMixin_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );

  if( process.platform === 'darwin' )
  var plist = require( 'plist' );
}

var _ = wTools;
var Abstract = _.PlatformProvider.Abstract;

//

function _mixin( cls )
{

  var dstProto = cls.prototype;

  _.assert( arguments.length === 1 );
  _.assert( _.routineIs( cls ) );

  _.mixinApply
  ({
    dstProto : dstProto,
    descriptor : Self,
  });

}

//

function _xvfbDisplayGet()
{
  _.assert( arguments.length <= 1 );

  var o = { display : arguments[ 0 ] };

  _.routineOptions( _xvfbDisplayGet, o );

  _.assert( _.numberIs( o.display ) );

  var exists = ( filePath ) => _.objectIs( _.fileProvider.fileStat( filePath ) );

  var xvfbLockFile;

  do
  {
    xvfbLockFile = `/tmp/.X${o.display}-lock`;
    o.display += 1;
  }
  while( exists( xvfbLockFile ) );

  o.display -= 1;

  return o.display;
}

_xvfbDisplayGet.defaults =
{
  display : 99
}

//

function _xvfbDisplaySet( display )
{
  var self = this;

  _.assert( _.numberIs( display ) );

  var _xvfbDisplaySetup = `Xvfb :${display} -screen 0 800x600x24 &`;

  return _.shell( _xvfbDisplaySetup )
  .ifNoErrorThen( function()
  {
    return _.shell
    ({
      mode : 'spawn',
      code : 'pidof Xvfb',
    })
    .ifNoErrorThen( function( o )
    {
      self._xvfbDisplayPid = Number.parseFloat( o.output );
    })
  });
}

//

function _xvfbDisplayKill()
{
  var self = this;

  var con = new wConsequence().give();

  /*
    Kill xvfb display instance with delay to avoid X server error
    "Resource temporarily unavailable on X server :display"
  */

  con.timeOutThen( 1000, function()
  {
    if( self.verbosity )
    console.log( 'Killing Xvfb display instance, pid: ' + self._xvfbDisplayPid );

    var res = process.kill( self._xvfbDisplayPid );
    _.assert( res, 'Display process: ' +  self._xvfbDisplayPid + ' not killed' );
  })

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

  if( _.fileProvider.fileStat( self._plistPath ) )
  {
    var raw = _.fileProvider.fileRead( self._plistPath );
    var list = plist.parse( raw );
    if( _.definedIs( list[ 'LSBackgroundOnly' ] ) )
    {
      delete list[ 'LSBackgroundOnly' ];
      raw = plist.build( list );
      _.fileProvider.fileWrite( self._plistPath, raw );

      self._plistChanged = false;
    }
  }
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

var Supplement =
{

  _xvfbDisplayGet : _xvfbDisplayGet,
  _xvfbDisplaySet : _xvfbDisplaySet,
  _xvfbDisplayKill : _xvfbDisplayKill,

  _plistPathGet : _plistPathGet,
  _plistEdit : _plistEdit,
  _plistRestore : _plistRestore,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

}

//

var Self =
{

  supplement : Supplement,

  name : 'PlatformProviderMixin',
  _mixin : _mixin,

}

//

// Object.setPrototypeOf( Self, Supplement );

_.PlatformProvider = _.PlatformProvider || Object.create( null );
_.PlatformProvider.AdvancedMixin = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = wTools[ Self.nameShort ] = _.mixinMake( Self );

})();
