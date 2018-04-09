( function _Launcher_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../launcher/ScriptLauncher.s' );

  var _ = wTools;

  _.include( 'wTesting' );
}

//

var _ = wTools;
var Parent = wTools.Testing;

//

function providersGet( test )
{
  test.description = 'get list of avaible providers';
  var providersMap = wScriptLauncher.providersGet();
  test.shouldBe( _.objectIs( providersMap ) );
  test.shouldBe( _.mapOwnKeys( providersMap ).length > 0 );
}

//

var Self =
{

  name : 'wScriptLauncher test',
  tests :
  {
    providersGet : providersGet
  },

}

//

Self = wTestSuit( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
