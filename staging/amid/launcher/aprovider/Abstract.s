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

function _shell( appPath, flags )
{
  var self = this;
  var code;

  if( self.usingOsxOpen )
  {
    if( !self.osxOpenOptions )
    self.osxOpenOptions = '-W -n -j -g -a';

    code = 'open ' + self.osxOpenOptions + ' ' + appPath + ' --args ' + flags
  }
  else
  {
    code = appPath + ' ' + flags;
  }

  self._shellOptions =
  {
    mode : 'shell',
    code : code,
    stdio : 'ignore',
    outputPiping : 0,
    verbosity : self.verbosity,
  }

  return _.shell( self._shellOptions );
}

// --
// relationship
// --

var Composes =
{
  url : null,
  headless : true,
  verbosity : 1,
  osxOpenOptions : null
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
  _shellOptions : null
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

  _shell : _shell,


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
