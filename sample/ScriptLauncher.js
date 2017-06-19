if( typeof module !== 'undefined' )
{
  require( '../staging/amid/launch/ScriptLauncher.s' );
}

var _ = wTools;

/**/

var args = _.appArgs();

var launcher = wScriptLauncher
({
  headless : false,
  filePath : args.map.filePath
});

launcher.launch()
.got( function ( err, provider )
{
  if( err )
  throw _.errLog( err );

  console.log( provider );
});
