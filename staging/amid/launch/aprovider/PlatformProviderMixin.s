( function _PlatformProviderMixin_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );

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
