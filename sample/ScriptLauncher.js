if( typeof module !== 'undefined' )
{
  require( '../staging/amid/launch/ScriptLauncher.s' );
}

var _ = wTools;

/**/

var launcher = wScriptLauncher
({
  providerOptions : { url : 'http://localhost:3000', headless : false }
});
launcher.launch()
.got( function ( err, provider )
{
  if( err )
  throw err;

  console.log( provider );
});
