( function _Node_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );
}

var _ = wTools;

//

var Parent = _.PlatformProvider.Abstract;
var Self = function wPlatformProviderNode( o )
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

  var con = new _.Consequence();

  var which =  require( 'which' );
  which( 'node', function ( err, path )
  {
    if( err )
    throw _.err( err );

    self._appPath = _.fileProvider.path.nativize( path );
    self._flags = [ self.url ];
    con.take( null );
  })


  con.then( function ()
  {
    self._shellOptions =
    {
      mode : 'spawn',
      execPath : self._appPath,
      args : self._flags,
      stdio : 'pipe',
      outputPiping : 1,
      verbosity : self.verbosity,
    }

    return _.shell( self._shellOptions );
  })

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
_.PlatformProvider.Node = Self;

if( typeof module !== 'undefined' )
if( !_.PlatformProvider.Default )
{
  _.PlatformProvider.Default = Self;
}

})();
