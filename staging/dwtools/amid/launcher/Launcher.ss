#! /usr/bin/env node

if( typeof module !== "undefined" )
{
  require( './ScriptLauncher.s' );

  var launcher = wScriptLauncher({});
  launcher.argsApply();
  if( !wScriptLauncher.helpOnly )
  launcher.launch();
}
