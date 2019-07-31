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

//

function _scriptGet()
{
  var self = this;
  var con = new _.Consequence();

  var requestUrl = _.uri.uriJoin( self.parsedUrl.origin, 'script' )
  request( requestUrl, function ( data )
  {
     self.script = JSON.parse( data );

     //get launch options from server
     var requestUrl = _.uri.uriJoin( self.parsedUrl.origin, 'options' )
     request( requestUrl, function ( data )
     {
       self.options = JSON.parse( data );
       con.take( null );
     })
  });

  con.then( () =>
  {
    console.log( self.script );

    if( self.options.debug )
    return _.timeOut( 2000 );
    
    return null;
  })

  return con;
}

//

function _beforeRun()
{
  var self = this;

  if( self.options.platform !== 'firefox' )
  _global_.onbeforeunload = function terminate()
  {
    var terminateUrl = _.uri.uriJoin( self.parsedUrl.origin, 'terminate' );
    request( terminateUrl );
  }

  _.io = io;

  self.loggerToServer = new _.LoggerToSever({ url : window.location.href });
  self.loggerToServer.permanentStyle = { bg : 'yellow', fg : 'black' };

  if( _.Tester )
  {
    var test = _.timeReadyJoin( undefined,_.Tester.test );
    var loggerPermanentStyle = _.mapExtend( {}, self.loggerToServer.permanentStyle );

    _.Tester.test = ( suiteName ) =>
    {
      self.loggerToServer.inputUnchain( console );
      _.Tester.logger.onTransformEnd = ( o ) =>
      {
        self.loggerToServer.log( o.outputForPrinter[ 0 ] );
      };
      self.loggerToServer.permanentStyle = null;

      self.testLauncher = test.call( _.Tester, suiteName );

      self.testLauncher.tap( () =>
      {
        self.loggerToServer.permanentStyle = loggerPermanentStyle;
        self.loggerToServer.inputFrom( console );
        self.scriptLauncher.take( null );
      });

      return self.testLauncher;
    }
  }

  self.loggerToServer.inputFrom( console );
  return self.loggerToServer.connect();
}

//

function run ()
{
  var self = this;
  self.parsedUrl = _.uri.uriParse( window.location.href );

  return new _.Consequence().take( null )
  .then( () => self._scriptGet() )
  .then( () => self._packagesPrepare() )
  .then( () => self._beforeRun() )
  .then( () => self._scriptRun() )
  .then( ( err ) =>
  {
    if( err )
    _.errLog( err );

    if( self.options.terminatingAfter )
    return self.terminate();
    
    return null;
  });
}

//

function _scriptRun()
{
  var self = this;

  self.scriptLauncher = new _.Consequence().take( null );

  var files = self.script.files;
  for( var i = 0; i < files.length; i++ )
  {
    self.scriptLauncher.got( () =>
    {
      return RemoteRequire.require( files[ i ] )
    });
  }

  return self.scriptLauncher;
}

function _packagesPrepare()
{
  var self = this;
  var packages  =
  [
    // 'wTesting',
  ];

  for( var i = 0; i < packages.length; i++ )
  {
    _.include( packages[ i ] );
  }
  
  return true;
}

//

function terminate()
{
  var self = this;

  var con = self.loggerToServer.disconnect();
  con.got( function ()
  {
    var requestUrl = _.uri.uriJoin( self.parsedUrl.origin, 'terminate' );
    request( requestUrl, () => con.take( null ) );
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
  scriptLauncher : null,
  testLauncher : null
}

var Statics =
{
  run : run,
  _scriptRun : _scriptRun,
  terminate : terminate,
  _scriptGet : _scriptGet,
  _scriptRun : _scriptRun,
  _packagesPrepare : _packagesPrepare,
  _beforeRun : _beforeRun
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

_.classDeclare
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
_global_[ '_remoteRequire' ].resolve = RemoteRequire.resolve;
_global_[ Self.nameShort ].run();

})();
