( function _PlatformProviderAbstract_s_() {

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

  if( self.Self === Self )
  Object.preventExtensions( self );

  if( o )
  self.copy( o );

  if( self.verbosity )
  logger.log( 'new',_.strTypeOf( self ) );

}

//

function run()
{
  var self = this;
  return self.runAct();
}

// --
// relationship
// --

var Composes =
{
  url : null
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

_.PlatformProvider = _.PlatformProvider || {};
_.PlatformProvider.Abstract = Self;

if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = Self;
}

})();
