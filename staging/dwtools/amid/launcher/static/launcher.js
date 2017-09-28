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


function _prepare()
{
  var self = this;
  var con = new wConsequence();

  self.parsedUrl = _.urlParse( window.location.href );

  var requestUrl = _.urlJoin( self.parsedUrl.origin, 'script' )
  request( requestUrl, function ( data )
  {
     self.script = JSON.parse( data );

     //get launch options from server
     var requestUrl = _.urlJoin( self.parsedUrl.origin, 'options' )
     request( requestUrl, function ( data )
     {
       self.options = JSON.parse( data );
       con.give();
     })
  })

  con.doThen( () =>
  {
    if( self.options.platform !== 'firefox' )
    _global_.onbeforeunload = function terminate()
    {
      var terminateUrl = _.urlJoin( self.parsedUrl.origin, 'terminate' );
      request( terminateUrl );
    }

    if( self.options.debug )
    return _.timeOut( 2000 );
  })

  con.doThen( () =>
  {
    _.io = io;

    self.loggerToServer = new wLoggerToServer({ url : window.location.href });
    self.loggerToServer.permanentStyle = { bg : 'yellow', fg : 'black' };
    self.loggerToServer.inputFrom( console );
    return self.loggerToServer.connect();
  })

  return con;
}

//

function run ()
{
  var self = this;

  return new wConsequence().give()
  .doThen( () => self._prepare() )
  .doThen( () => self.runAct() )
  .doThen( ( err ) =>
  {
    if( err )
    _.errLog( err );

    if( self.options.terminatingAfter )
    return self.terminate();
  });
}

//

function runAct()
{
  var self = this;

  var scriptLauncher = new wConsequence().give();

  if( _.Tester )
  {
    var test = _.timeReadyJoin( undefined,_.Tester._test );
    var loggerPermanentStyle = _.mapExtend( {}, self.loggerToServer.permanentStyle );

    _.Tester.test = ( suiteName ) =>
    {
      self.loggerToServer.inputUnchain( console );
      _.Tester.logger.onWrite = ( o ) =>
      {
        self.loggerToServer.log( o.output[ 0 ] );
      };
      self.loggerToServer.permanentStyle = null;

      var testLauncher = test.call( _.Tester, suiteName );

      testLauncher.tap( () =>
      {
        self.loggerToServer.permanentStyle = loggerPermanentStyle;
        self.loggerToServer.inputFrom( console );
      });

      scriptLauncher.andThen( testLauncher );

      return testLauncher;
    }
  }

  var files = self.script.files;
  for( var i = 0; i < files.length; i++ )
  {
    scriptLauncher.ifNoErrorThen( () => RemoteRequire.require( files[ i ] ) );
  }

  return scriptLauncher;
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
  runAct : runAct,
  terminate : terminate,
  _prepare : _prepare
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
_global_[ Self.nameShort ].run();

})();
