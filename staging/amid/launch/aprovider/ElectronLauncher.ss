( function _ElectronLauncher_ss_() {

'use strict';

if( typeof module !== 'undefined' )
{

  require( 'wTools' );
  var electron = require( 'electron' );
}

var _ = wTools;

var app = electron.app;
var BrowserWindow = electron.BrowserWindow;

var args = _.appArgs().map;
var window;

module = null;

if( args == undefined )
args = {};

if( args.headless === undefined )
args.headless = false;

if( args.url === undefined )
args.url = 'http://127.0.0.1:3000';

function windowInit( )
{
  var o =
  {
    width: 1280, height: 720,
    webPreferences :
    {
      nodeIntegration : false
    }
  }

  if( args.headless )
  {
    o.show = false;
    o.frame = false;
  }

  window = new BrowserWindow( o );

  window.loadURL( args.url );

  window.webContents.openDevTools();

  window.on( 'closed', function ()
  {
    window = null;
  })

}

app.on( 'ready', windowInit );
app.on( 'browser-window-created', function ()
{
  if( _.routineIs( process.send ) )
  process.send( 'ready' );
})
app.on( 'window-all-closed', function ()
{
  // if ( process.platform !== 'darwin' )
  app.quit();
});

app.on( 'activate', function ()
{
  if ( window === null && !self.headless )
  windowInit();
})
})();
