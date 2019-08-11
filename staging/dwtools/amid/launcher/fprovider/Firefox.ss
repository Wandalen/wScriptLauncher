( function _Firefox_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{
  if( !wTools.PlatformProvider.Abstract )
  require( './PlatformProviderAbstract.s' );
}

var _ = wTools;

//

var Parent = _.PlatformProvider.Abstract;
var Self = function wPlatformProviderFirefox( o )
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

  self._appPath = require( 'firefox-location' );
}

//

function runAct()
{
  var self = this;

  var profilePath = _.path.resolve( __dirname, '../../../../tmp.tmp/firefox' );
  profilePath = _.fileProvider.path.nativize( profilePath );
  var userJsPath = _.path.join( profilePath, 'user.js' );
  userJsPath = _.fileProvider.path.nativize( userJsPath );

  self._flags =
  [
    self.url,
    '-no-remote',
    '-profile',
    profilePath
  ]

  function _createProfile()
  {
    self._appPath = _.fileProvider.path.nativize( self._appPath );
    var createProfile = self._appPath + ' -CreateProfile ' + ` "launcher ${profilePath}" `;

    return _.shell( createProfile )
    .then( function ()
    {
      var prefs =
      [
        'user_pref("browser.shell.checkDefaultBrowser", false );',
        'user_pref("browser.sessionstore.resume_from_crash", false);',
        'user_pref("browser.sessionstore.resume_session_once", false);'
      ]
      .join( '\n' );

      _.fileProvider.fileWrite( userJsPath, prefs );
    })
  }

  var con = new _.Consequence().take( null );

  /* if user.js doesn't exist -> create new profile and set user prefs. */

  if( !_.objectIs( _.fileProvider.fileStat( userJsPath ) ) )
  con.then( () => _createProfile() );

  if( self._headlessNoFocus )
  self._plistEdit();

  if( self.headless && process.platform === 'linux' )
  {
    var display = self._xvfbDisplayGet();
    con.then( () => self._xvfbDisplaySet( display ) );
    con.then( () => self._flags.push( `--display=:${display}` ) );
  }

  con.then( () => self._shell() );

  if( self._plistChanged )
  con.then( () => self._plistRestore() );

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
_.PlatformProvider.Firefox = Self;

if( typeof module !== 'undefined' )
if( !_.PlatformProvider.Default )
_.PlatformProvider.Default = Self;

})();
