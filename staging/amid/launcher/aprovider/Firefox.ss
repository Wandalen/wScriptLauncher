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

  var profilePath = _.pathResolve( __dirname, '../../../../tmp.tmp/firefox' );
  var userJsPath = _.pathJoin( profilePath, 'user.js' );

  self._flags =
  [
    self.url,
    '-no-remote',
    '-profile',
    profilePath
  ]

  function _createProfile()
  {
    var createProfile = self._appPath + ' -CreateProfile ' + ` "launcher ${profilePath}" `;

    return _.shell( createProfile )
    .doThen( function ()
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

  var con = new wConsequence().give();

  /* if user.js doesn't exist -> create new profile and set user prefs. */

  if( !_.objectIs( _.fileProvider.fileStat( userJsPath ) ) )
  con.doThen( () => _createProfile() );

  if( self._headlessNoFocus )
  self._plistEdit();

  if( self.headless && process.platform === 'linux' )
  {
    var display = self._xvfbDisplayGet();
    con.doThen( () => self._xvfbDisplaySet( display ) );
    con.doThen( () => self._flags.push( `--display=:${display}` ) );
  }

  con.doThen( function()
  {
    self._shellOptions =
    {
      mode : 'spawn',
      code : self._appPath + ' ' + self._flags.join( ' ' ),
      // stdio : 'ignore',
      outputPiping : 1,
      verbosity : self.verbosity,
    }

    return self._shell()
  })


  if( self._plistChanged )
  con.doThen( () => self._plistRestore() );

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

_.PlatformProvider.AdvancedMixin.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.PlatformProvider.Firefox = Self;

if( typeof module !== 'undefined' )
if( !_.PlatformProvider.Default )
_.PlatformProvider.Default = Self;

})();
