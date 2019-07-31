
(function _Launcher_js_() {

'use strict';

var remoteRequire = new wRemoteRequire();

// window[ 'RemoteRequire' ] = remoteRequire;
// window[ '_remoteRequire' ].resolve = remoteRequire.resolve;

debugger

require( 'wTools' );

var _ = _global_.wTools;

_.include( 'wProto' );
_.include( 'wWebUriFundamentals' );
_.include( 'wloggertoserver' );
_.include( 'socket.io-client/dist/socket.io.js' );
_.include( 'wFiles' );
_.include( 'wTesting' );

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

//

function _urlJoin( path )
{
  var self = this;

  _.assert( arguments.length === 1 );
  _.assert( _.objectIs( self.parsedUrl ) );

  return _.uri.join( self.parsedUrl.origin, path );
}

//

function _scriptGet()
{
  var self = this;
  var con = new _.Consequence().take( null );

  self.script = _.fileProvider.fileReadJson( self._urlJoin( 'script' ) )
  self.options = _.fileProvider.fileReadJson( self._urlJoin( 'options' ) )

  // console.log( self.script );

  if( self.options.debug )
  return _.timeOut( 2000 );

  return con;
}

//

function _beforeRun()
{
  var self = this;

  if( self.options.platform !== 'firefox' )
  _global_.onbeforeunload = function terminate()
  {
    _.fileProvider.fileRead( self._urlJoin( 'terminate' ) );
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

      _.Tester.logger.onTransformEnd = ( o ) => self.loggerToServer.log( o.outputForPrinter[ 0 ] );

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

  self.parsedUrl = _.uri.parse( window.location.href );

  return new _.Consequence().take( null )
  .then( () => self._scriptGet() )
  // .then( () => self._packagesPrepare() )
  .then( () => self._beforeRun() )
  .then( () => self._scriptRun() )
  .finally( ( err, got ) =>
  {
    if( err )
    _.errLog( err );

    if( self.options.terminatingAfter )
    return self.terminate();
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
    self.scriptLauncher.then( () =>
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
}

//

function terminate()
{
  var self = this;

  var con = self.loggerToServer.disconnect();
  var terminateUrl = self._urlJoin( 'terminate' );
  var terminateCon = _.fileProvider.fileRead({ filePath : terminateUrl, sync : 0 });
  con.then( terminateCon );

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
  _beforeRun : _beforeRun,
  _urlJoin : _urlJoin,
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
_global_[ Self.nameShort ].run();

})();


