
if( typeof module !== 'undefined' )
require( 'wscriptlauncher' );

var _ = wTools;

/* Initialize launcher with provided options object */

var launcher = wScriptLauncher
({
  filePath : _.pathResolve( __dirname, './helloworld.js' ),
  headless : true,
  platform : 'chrome',
  terminatingAfter : true,
  verbosity : 1
});

/* Run our script file on target platform by calling launch, it
   returns wConsequence object which gives us a message with platform provider
   when all work will be done. More about wConsequence - https://github.com/Wandalen/wConsequence
*/

launcher.launch()
.got( function ( err, provider )
{
  if( err )
  throw _.errLog( err );

  console.log( provider );
});
