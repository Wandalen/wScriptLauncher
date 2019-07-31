( function _BrowserStack_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );

  var webdriver = require( 'selenium-webdriver' );
  var browserstack = require( 'browserstack-local' );
}

var _ = wTools;

//

var Parent = _.PlatformProvider.Abstract;
var Self = function wPlatformProviderBrowserStack( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'BrowserStack';

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );

  // if( !self.configPath )
  // self.configPath = _.path.resolve( __dirname, _.strDup( '../', 5 ), 'browserstack.json' );
}

//

function runAct()
{
  var self = this;

  // console.log( 'url:', self.url );

  self._prepareCapabilities();

  var bsKey = self.capabilities[ 'browserstack.key' ];

  self.con = self.runBrowserstackLocal( bsKey )
  .got( ( err, got ) =>
  {
    if( err )
    return self.con.error( err );

    webdriver.promise.controlFlow().on( 'uncaughtException', function( err )
    {
      self.con.error( err );
    });

    self.driver = new webdriver.Builder()
    .usingServer('http://hub-cloud.browserstack.com/wd/hub')
    .withCapabilities( self.capabilities )
    .build();

    self.driver.get( self.url );

    // var untilOpened = new webdriver.Condition( 'browser is closed', ( d ) =>
    // {
    //   return d.getTitle().then( () => false, () => true );
    // })

    // var closed = self.driver.wait( untilOpened );
    // var con = _.Consequence.from( closed );

    // con.then( () =>
    // {
    //   return _.Consequence.from( self.driver.quit() )
    // })


  })

  return self.con;
}

//

function terminateAct()
{
  var self = this;

  if( self.driver )
  {
    var quit = self.driver.quit();
    self.con
    .take( null )
    .then( _.Consequence.From( quit ) )
    .then( () => self.stopBrowserstackLocal() );
  }
  else
  {
    return new _.Consequence().take( null );
  }


  return self.con;
}

//

function _prepareCapabilities()
{
  var self = this;

  if( self.capabilities === null )
  self.capabilities = {};

  _.assert( _.objectIs( self.capabilities ) );

  if( self.configPath )
  {
    self.configPath = _.path.resolve( _.path.current(), self.configPath );

    if( !_.fileProvider.fileStat( self.configPath ) )
    throw _.err( 'Provided config path not exist:', self.configPath );

    var capabilitiesFromFile = _.fileProvider.fileReadJson( self.configPath );
    _.mapSupplementNulls( self.capabilities, capabilitiesFromFile );
  }

  _.mapSupplementNulls( self.capabilities, defaultCapabilities );

  Object.setPrototypeOf( self.capabilities, Object.prototype );

  if( !self.mapHasAllNotNull( self.capabilities, requiredCapabilities ) )
  {
    var msg =
    'Some of required capabilities are not provided: \n'
    + _.mapOwnKeys( requiredCapabilities ).toString()
    + '\nPlease provide them through config file or options.'

    throw _.err( msg );
  }
}

//

function runBrowserstackLocal( accessKey )
{
  var self = this;

  _.assert( arguments.length === 1 );

  self.browserstackLocal = new browserstack.Local();

  var con = new _.Consequence();

  var args =
  {
    'key' : accessKey,
    'verbose' : true,
    'forceLocal' : true
  }

  self.browserstackLocal.start( args, () => con.take( null ) );

  return con;
}

//

function stopBrowserstackLocal()
{
  var self = this;
  var con = new _.Consequence();

  if( self.browserstackLocal.isRunning() )
  self.browserstackLocal.stop( () =>
  {
    _.assert( !self.browserstackLocal.isRunning() );
    con.take( null );
  })
  else
  con.take( null );

  return con;
}

//

var requiredCapabilities =
{
  'browserstack.user' : '',
  'browserstack.key' : ''
}

/* https://www.browserstack.com/automate/capabilities */

var defaultCapabilities =
{
  'browserName' : 'chrome',
  'os' : 'OS X',
  'os_version' : 'El Capitan',
  'browserstack.local' : true,
  'browserstack.debug' : false,
  'browserstack.video' : false,
  'build' : 'Testing'
}

// --
// relationship
// --

var Composes =
{
  configPath : null,
  capabilities : null
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
  driver : null,
  con : null,
  browserstackLocal : null
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

  runAct : runAct,
  terminateAct : terminateAct,

  //etc

  _prepareCapabilities : _prepareCapabilities,

  runBrowserstackLocal : runBrowserstackLocal,
  stopBrowserstackLocal : stopBrowserstackLocal,

  //

  //constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics

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
_.PlatformProvider.BrowserStack = Self;

if( typeof module !== 'undefined' )
if( !_.PlatformProvider.Default )
{
  _.PlatformProvider.Default = Self;
}

})();
