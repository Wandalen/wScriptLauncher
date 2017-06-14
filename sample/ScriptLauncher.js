if( typeof module !== 'undefined' )
{
  require( '../staging/amid/launch/ScriptLauncher.s' );
}

var _ = wTools;

/**/

var launcher = wScriptLauncher
({
  providerOptions : { url : '127.0.0.1:3000' }
});
launcher.launch()
.got( function ( err, provider )
{
  if( err )
  throw err;

  console.log( provider );
});
