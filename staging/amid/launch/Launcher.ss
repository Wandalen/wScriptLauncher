#! /usr/bin/env node

if( typeof module !== "undefined" )
{

  require( './ScriptLauncher.s' );

  var _ = wTools;

  var args = _.appArgs();

  var launcher = wScriptLauncher
  ({
    headless : args.map.headless,
    filePath : args.map.filePath,
    browser : args.map.browser
  });

  launcher.launch()
  .ifErrorThen( function ( err )
  {
    throw _.errLog( err );
  });
}
