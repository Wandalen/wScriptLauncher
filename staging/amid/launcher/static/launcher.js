(function _Launcher_js_() {

'use strict';

var _ = wTools;
var Parent = null;
var RemoteRequire = new wRemoteRequireClient();
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

  var requestUrl = _.urlJoin( self.parsedUrl.origin, 'script' )
  request( requestUrl, function ( data )
  {
     data = JSON.parse( data );
     self.script =
     {
       module : _.routineMake({ code : data.script, prependingReturn : 0, usingStrict : 0 } ),
       realPath : data.filePath
     };
     RemoteRequire.map[ self.script.realPath ] = self.script;

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
    if( self.options.platform !== 'firefox' )
    _global_.onbeforeunload = function terminate()
    {
      var terminateUrl = _.urlJoin( self.parsedUrl.origin, 'terminate' );
      request( terminateUrl );
    }

    _.io = io;
    wLogger.rawOutput = true;
    self.loggerToServer = new wLoggerToServer({ url : window.location.href });
    self.loggerToServer.permanentStyle = { bg : 'yellow', fg : 'black' };
    self.loggerToServer.inputFrom( console );
  })
  .doThen( () => self.loggerToServer.connect() )
  .doThen( () =>
  {
    RemoteRequire.currentPath = self.script.realPath;
    debugger
    self.script.module();
  })
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

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

// --
// export
// --


_global_[ Self.nameShort ] = Self;
_global_[ 'RemoteRequire' ] = RemoteRequire;
_global_[ 'require' ] = RemoteRequire.require.bind( RemoteRequire );
_global_[ Self.nameShort ].run();

})();
