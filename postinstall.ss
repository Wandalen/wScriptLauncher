require( 'wTools' );
require( 'wConsequence' );

var _ = wTools;

if( process.platform !== 'linux' )
return;

_.shell( 'sudo apt-get install xvfb' );
