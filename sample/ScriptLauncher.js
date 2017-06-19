if( typeof module !== 'undefined' )
{
  require( '../staging/amid/launcher/ScriptLauncher.s' );
}

var _ = wTools;

/**/

var args = _.appArgs();

var launcher = wScriptLauncher
({
  headless : false,
  filePath : _.pathResolve( __dirname, './helloworld.js' )
});

launcher.launch()
.got( function ( err, provider )
{
  if( err )
  throw _.errLog( err );

  console.log( provider );
});
