(function _Launcher_js_() {

'use strict';


var _ = wTools;
var Parent = null;
var Self = function Launcher( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = '__launcher__';

//

function init( o )
{
  var self = this;

  _.assert( arguments.length === 0 | arguments.length === 1 );

  if( o )
  self.copy( o )
}

function request( url, onResponse )
{
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function ()
    {
      if ( xmlHttp.readyState == 4 && xmlHttp.status == 200 )
      if( _.routineIs( onResponse ) )
      onResponse( xmlHttp.responseText );
    }
    xmlHttp.open( "GET", url, true );
    xmlHttp.send( null );
}

function getScript()
{
  var self = this;
  var con = new wConsequence();
  self.parsedUrl = _.urlParse( window.location.href );

  //window closed -> terminate
  _global_.onbeforeunload = function terminate()
  {
    var teminateUrl = _.urlJoin( self.parsedUrl.origin, 'terminate' );
    request( teminateUrl );
  }

  var requestUrl = _.urlJoin( self.parsedUrl.origin, 'script' )
  request( requestUrl, function ( data )
  {
     self.script = _.routineMake({ code : data, prependingReturn : 0 } );

     //get launch options from server
     var requestUrl = _.urlJoin( self.parsedUrl.origin, 'options' )
     request( requestUrl, function ( data )
     {
       self.options = JSON.parse( data );
       con.give();
     })
  })

  return con;
}

//

function run ()
{
  var self = this;

  return self.getScript()
  .doThen( function ()
  {
    _.io = io;
    wLogger.rawOutput = true;
    self.loggerToServer = new wLoggerToServer({ url : window.location.href });
    self.loggerToServer.permanentStyle = { bg : 'yellow', fg : 'black' };
    self.loggerToServer.inputFrom( console );
  })
  .doThen( () => self.loggerToServer.connect() )
  .doThen( () => self.script() )
  .doThen( function ()
  {
    if( self.options.terminatingAfter )
    return self.terminate();
  })
}

//

function terminate()
{
  var self = this;

  var con = self.loggerToServer.disconnect();
  con.got( function ()
  {
    var requestUrl = _.urlJoin( self.parsedUrl.origin, 'terminate' );
    request( requestUrl, () => con.give() );
  })

 return con;
}

// --
// relationships
// --

var Restricts =
{
  script : null,
  parsedUrl : null,
  loggerToServer : null,
  options : null,
}

var Statics =
{
  run : run,
  terminate : terminate,
  getScript : getScript
}

// --
// prototype
// --

var Proto =
{

  init : init,

  // relationships

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

// --
// export
// --


_global_[ Self.nameShort ] = Self;
_global_[ Self.nameShort ].run();

})();
