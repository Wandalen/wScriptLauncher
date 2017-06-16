( function _ScriptLauncher_s_() {

'use strict';

if( typeof module !== 'undefined' )
{
  require( 'wTools' );

  wTools.include( 'wProto' );
  wTools.include( 'wFiles' );
  wTools.include( 'wPath' );
  wTools.include( 'wConsequence' );
  wTools.include( 'wCopyable' );

  require( './aprovider/Abstract.s' );
  require( './aprovider/AdvancedMixin.s' );
  require( './aprovider/Chrome.ss' );
  require( './aprovider/Firefox.ss' );
}

//

var _ = wTools;
var Parent = null;
var Self = function wScriptLauncher( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'ScriptLauncher';

//

function init( o )
{
  var self = this;

  _.instanceInit( self );

  Object.preventExtensions( self );

  if( o )
  self.copy( o );
}

//

function launch()
{
  var self = this;
  self._serverStart();

  self.launchDone.got( function ( err )
  {
    if( err )
    throw _.err( err );

    var provider = _.PlatformProvider.Chrome( self.providerOptions );
    provider.run()
    .got( function ( err )
    {
      if( err )
      throw _.err( err );

      self.launchDone.give( provider )
    })
  });

  return self.launchDone;
}

//

function _serverStart( )
{
  var self = this;

  var express = require( 'express' );
  var app = express();
  var server = require( 'http' ).createServer( app );
  var io = require( 'socket.io' )(server);
  var port = 3000;

  app.use( express.static( '.' ) );

  app.get('/', function (req, res)
  {
    res.sendFile( _.pathResolve( './sample/Sample1.html' ));
  });

  io.on( 'connection', function( client )
  {
    client.on( 'join', function()
    {
      console.log( 'connected' );
      client.on ('log', function ( msg )
      {
        logger.log( msg );
      });
    });
  });

  server.listen( port, function ()
  {
    console.log( 'Server started on port ', port );
    self.launchDone.give();
  });
}

// --
// relationship
// --

var Composes =
{
  providerOptions : null,
  launchDone : new wConsequence()
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

  //

  launch : launch,

  _serverStart : _serverStart,

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

wCopyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

})();
