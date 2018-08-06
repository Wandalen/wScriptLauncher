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

  require( './Tools.ss' );
  require( 'wremoterequire' );

  require( './fprovider/Abstract.s' );
  require( './fprovider/AdvancedMixin.s' );
  require( './fprovider/Chrome.ss' );
  require( './fprovider/Firefox.ss' );
  require( './fprovider/Electron.ss' );
  require( './fprovider/Node.ss' );
  require( './fprovider/BrowserStack.ss' );

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

  // _.assert( o.filePath, 'wScriptLauncher expects mandatory option filePath' )

  if( o )
  self.copy( o );
}

//

function argsApply()
{
  var self = this;
  var args = _.appArgs();

  _.assert( arguments.length === 0 );

  args.map.filePath = args.map.filePath || args.subject;

  if( !args.scriptArgs.length )
  {
    logger.log( Self.helpGet() );
    Self.helpOnly = true;
    return self;
  }

  self.copy( _.mapScreen( Self.prototype.copyableArgs, args.map ) );

  if( self.terminatingAfter === null )
  self.terminatingAfter = self.headless;

  return self;
}

//

function launch()
{
  var self = this;

  self.launchDone = self._xvfbCheck();

  var feedback = new wConsequence();

  process.on( 'SIGINT', function()
  {
    /* terminate kills provider and server then reports feedback and shutdowns the launcher */

    var con = self.terminate();

    if( self.handlingFeedback )
    con.doThen( () => feedback.give( self._provider ) );
    else
    self.launchDone.give();

    self.launchDone.doThen( () => process.exit() );
  });

  if( self.platform === 'node' )
  {
    self.launchDone
    .ifNoErrorThen( () => self._platformLaunch() )
    .ifNoErrorThen( () => feedback.give( self._provider ) );
  }
  else
  {
    self.launchDone
    .ifNoErrorThen( () => self._scriptPrepare() )
    .ifNoErrorThen( () => self._preparePort() )
    .ifNoErrorThen( () => self._serverLaunch() )

    if( !self.serverOnly )
    {
      self.launchDone
      .ifNoErrorThen( () => self._platformLaunch() )
      .ifNoErrorThen( () => feedback.give( self._provider ) );
    }
  }

  self.launchDone.ifErrorThen( ( err ) =>
  {
    self.terminate()
    .got( () => feedback.error( err ) );
  });

  if( self.handlingFeedback )
  feedback
  .got( function ( err,got )
  {
    if( err )
    throw _.errLog( err );

    logger.log( got );

    self.launchDone.give()
  });

  return self.launchDone;
}

//

function terminate()
{
  var self = this;

  var con = new wConsequence().give();

  if( self._provider )
  con.doThen( () => self._provider.terminate() );

  if( self.remoteRequireServer )
  con.doThen( () => self.remoteRequireServer.stop() )

  if( self.server && self.server.isRunning )
  con.doThen( () => self.server.io.close( () => self.server.close() ) );

  return con;
}

//

function _preparePort()
{
  var self = this;

  return _.portGet( self.serverPort )
  .doThen( ( err, port ) =>
  {
    if( err )
    throw _.err( err );

    self.serverPort = port
  });
}
//

function _serverLaunch( )
{
  var self = this;
  var nativize = _.fileProvider.nativize;
  var con = new wConsequence();
  var rootDir = _.resolve( __dirname, '../../../..' );

  // var script = _.fileProvider.fileRead( self.filePath );
  var express = require( 'express' );
  var app = express();
  self.server = require( 'http' ).createServer( app );
  self.server.io = require( 'socket.io' )( self.server );

  var statics = nativize( _.join( rootDir, 'staging/dwtools/amid/launcher/static' ) );
  var modules = nativize( _.join( rootDir, 'node_modules' ) );

  self.remoteRequireServer = _.RemoteRequireServer
  ({
    app : app,
    serverPort : self.serverPort,
    verbosity : self.verbosity,
    rootDir : _.dir( self.filePath )
  });
  self.remoteRequireServer.start();

  app.use( '/modules', express.static( modules ) );
  app.use( '/static', express.static( statics ) );

  app.get( '/', function ( req, res )
  {
    res.sendFile( nativize( _.join( statics, 'index.html' ) ) );
  });

  // app.get( '/include', function ( req, res )
  // {
  //   var includePath = './include.js';

  //   res.send( JSON.stringify( { include : includePath } ) );
  // });

  app.get( '/script', function ( req, res )
  {
    var stat = _.fileProvider.fileStat( self.filePath );

    var files;

    if( stat.isDirectory() )
    {
      if( self.includingTests  )
      {
        files = _.fileProvider.filesFind
        ({
          filePath : self.filePath,
          relative : self.remoteRequireServer.rootDir,
          outputFormat : 'relative',
          ends : [ '.test.s','.test.js' ],
          recursive : 1,
          maskAll : _.regexpMakeSafe(),
        });
      }
    }
    else
    {
      files = [ _.dot( _.relative( self.remoteRequireServer.rootDir, self.filePath ) ) ];
    }

    res.send( JSON.stringify( { files : files } ) );
  });

  app.get( '/options', function ( req, res )
  {
    res.send
    ({
      terminatingAfter : self.terminatingAfter,
      platform : self.platform,
      debug : self.debug
    });
  });

  app.get( '/terminate', function ( req, res )
  {
    self.terminate();
  });

  self.server.io.on( 'connection', function( client )
  {
    client.on( 'join', function ( msg, reply )
    {
      if( self.verbosity >= 3 )
      logger.log( 'wLoggerToServer connected' );
      reply();
    });

    client.on ( 'log', function ( msg, reply )
    {
      if( self.verbosity >= 1 )
      logger.log( msg );
      reply();
    });

    // client.on( 'terminate', function ()
    // {
    //   if( self.terminatingAfter )
    //   self.terminate();
    // });

    // client.on( 'disconnect', function ()
    // {
    // })
  });


  self.server.listen( self.serverPort, function ()
  {
    if( self.verbosity >= 3 )
    logger.log( 'Server started on port ', self.serverPort );

    if( self.serverOnly )
    console.log( `http://localhost:${self.serverPort}` );

    self.server.isRunning = true;
    con.give();
  });

  return con;
}

//

function _scriptPrepare()
{
  var self = this;
  var con = new wConsequence();

  if( !self.filePath )
  {
    self._script = function(){ logger.log( wScriptLauncher.helpGet() ) };
    con.give();
  }
  else
  {
    self.filePath = _.fileProvider.nativize( _.resolve( _.current(), self.filePath ) );
    console.log( self.filePath )
    var stat = _.fileProvider.fileStat( self.filePath );
    if( stat )
    con.give();
    else
    con.error( _.err( self.filePath, ' not exist.' ) );
  }

  return con;
}

//

function _platformLaunch()
{
  var self = this;

  var provider = platformsMap[ self.platform ];
  if( provider === undefined )
  return self.launchDone.error( 'Requested browser is not supported.' );

  var providerOptions =
  {
    url : `http://localhost:${self.serverPort}`,
    headless : self.headless,
    verbosity : self.verbosity,
    usingOsxOpen : self.usingOsxOpen,
    allowPlistEdit : self.allowPlistEdit,
    debug : self.debug
  }

  if( self.platform === 'browserstack' )
  {
    var o =
    {
      configPath : self.bsConfigPath,
      capabilities :
      {
        'browserstack.user' : self.bsUser,
        'browserstack.key' : self.bsKey,
        'browserName' : self.bsBrowser,
        'os' : self.bsOs,
        'os_version' : self.bsOsVersion,
      }
    }

    _.mapExtend( providerOptions, o );
  }

  if( self.platform === 'node' )
  providerOptions.url = self.filePath;

  self._provider = provider( providerOptions );
  var result = self._provider.run();

  /* !!!workaround for chrome, process.on( 'close' ) wont work for some reason */
  if( self.platform === 'chrome' )
  result.doThen( () => { self.terminate() } );

  if( self._provider._shellOptions )
  self._provider._shellOptions.process.on( 'close', () =>  self.terminate() );

  return result;
}

//

function _xvfbCheck()
{
  var self = this;

  var con = new wConsequence().give();

  if( process.platform !== 'linux' || self.platform != 'firefox' || !self.headless )
  return con;

  con.got( function ()
  {
    var which =  require( 'which' );
    which( 'Xvfb', function ( notInstalled )
    {
      if( notInstalled )
      {
        var msg = 'Xvfb is not installed on your system, headless feature will be disabled.Please install xvfb to run provider in headless mode.'

        logger.log( _.strColor.bg( _.strColor.fg( msg, 'red' ) , 'yellow' ) );
        self.headless = false;
      }
      con.give();
    });
  })

  return con;
}

//

var platformsMap =
{
  'firefox' : _.PlatformProvider.Firefox,
  'chrome' : _.PlatformProvider.Chrome,
  'electron' : _.PlatformProvider.Electron,
  'node' : _.PlatformProvider.Node,
  'browserstack' : _.PlatformProvider.BrowserStack
}

//

function helpGet()
{
  var help =
  {
    'wScriptLauncher' : ' ',
    Usage :
    [
      'launcher [ path ]', 'launcher [ options ]',
      'Launcher expects path to script file as single argument or as option'
    ],
    Examples :
    [
      'launcher path/to/script.js',
      'launcher filePath : path/to/script.js platform : firefox headless : 0'
    ],
    Options :
    {
      filePath : 'Path to script file',
      platform : 'Target platform, that executes script file. Possible values : ' + _.mapOwnKeys( platformsMap ).join(),
      headless : 'Run without window. Possible values : 1/0',
    }
  }

  var strOptions =
  {
    levels : 3,
    wrap : 0,
    stringWrapper : '',
    multiline : 1
  };

  return _.toStr( help, strOptions );
}

//

function providersGet()
{
  return platformsMap;
}

// --
// relationship
// --

var Composes =
{
  filePath : null,
  platform : 'chrome',
  verbosity : 1,
  handlingFeedback : 1,
  includingTests: 1,
  serverOnly : 0,


  /* browser */

  headless : true,
  terminatingAfter : null,
  usingOsxOpen : 0,
  debug : 0,
  allowPlistEdit : 1,

  /* browserStack */

  bsUser : null,
  bsKey : null,
  bsBrowser : null,
  bsOs : null,
  bsOsVersion : null,
  bsConfigPath : null
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
  launchDone : new wConsequence(),
  server : null,
  serverPort : null,
  remoteRequireServer : null,

  _script : null,
  _provider : null,
}

var Statics  =
{
  helpGet : helpGet,
  helpOnly : false,
  providersGet : providersGet,
  copyableArgs : Object.create( null )
}

// --
// prototype
// --

var Proto =
{

  init : init,
  argsApply : argsApply,

  //

  launch : launch,
  terminate : terminate,

  _preparePort : _preparePort,
  _serverLaunch : _serverLaunch,
  _scriptPrepare : _scriptPrepare,
  _platformLaunch : _platformLaunch,
  _xvfbCheck : _xvfbCheck,


  //

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,

}

//

if( Proto.Composes )
_.mapExtend( Statics.copyableArgs,Proto.Composes );
if( Proto.Aggregates )
_.mapExtend( Statics.copyableArgs,Proto.Aggregates );
if( Proto.Associates )
_.mapExtend( Statics.copyableArgs,Proto.Associates );

//

_.classMake
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

//

if( typeof module !== 'undefined' && require.main === module )
{
  var launcher = wScriptLauncher({});
  launcher.argsApply();
  if( !wScriptLauncher.helpOnly )
  launcher.launch();
}

})();
