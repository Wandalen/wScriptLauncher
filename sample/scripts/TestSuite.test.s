( function _Test_test_s_( ) {

'use strict';

var _ = _global_.wTools;

//

var simplest = function( test )
{

  test.description = 'colorNameNearest bitmask';
  var color = 0xff0000;
  var got = _.color.rgbaFrom( color );
  var expected = [ 1,0,0,1 ];
  test.identical( got,expected );

  test.description = 'colorNameNearest name';
  var color = 'red';
  var got = _.color.rgbaFrom( color );
  var expected = [ 1,0,0,1 ];
  test.identical( got,expected );

  return _.timeOut( 6000 )
}
simplest.timeOut = 8000;

//

var Self =
{

  name : 'Test',
  silencing : 1,
  verbosity : 5,

  tests :
  {
    simplest : simplest,
  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
