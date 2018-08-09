
if( typeof module !== 'undefined' )
require( 'wscriptlauncher' );

var _ = wTools;

/* This sample shows how to use ScriptLauncher to run code from *.js file on choosen platform */

/* Initialize launcher by passing options object */

var launcher = wScriptLauncher
({
  filePath : _.path.resolve( __dirname, './scripts/TestSuite.test.s' ), // path to javascript file
  platform : 'chrome', // specifies targer platform, in out case its chrome browser
  headless : false, // runs chrome browser without window
  terminatingAfter : true, // terminates launcher browser after script execution
  verbosity : 1 // enables logging
});

/*
   Run the script file on target platform by calling launch, it
   returns wConsequence object which gives us a message with platform provider
   when all work will be done. More about wConsequence - https://github.com/Wandalen/wConsequence
*/

launcher.launch()
.got( function ( err, provider )
{
  if( err )
  throw _.errLogOnce( err );
  console.log( provider );
});
