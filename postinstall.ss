require( 'wTools' );
require( 'wConsequence' );

var _ = wTools;

if( process.platform !== 'linux' )
return;

var which =  require( 'which' );
which( 'Xvfb', function ( notInstalled )
{
  if( notInstalled )
  _.shell( 'sudo apt-get install xvfb' );
});
