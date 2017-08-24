( function _RemoteRequire_s_() {

  'use strict';

  if( typeof module !== 'undefined' )
  {
  }

  //

  var _ = wTools;
  var Parent = null;
  var Self = function wRemoteRequire( o )
  {
    if( !( this instanceof Self ) )
    if( o instanceof Self )
    return o;
    else
    return new( _.routineJoin( Self, Self, arguments ) );
    return Self.prototype.init.apply( this,arguments );
  }

  Self.nameShort = 'require';

  //

  function init( o )
  {
    var self = this;

    _.assert( arguments.length === 0 | arguments.length === 1 );

    if( o )
    self.copy( o )
  }

  function require( src )
  {
    var res;

    console.log( 'require : ', src )

    if( !RemoteRequire.currentPath )
    {
      var scripts = document.getElementsByTagName( "script" );
      var from = scripts[ scripts.length - 1 ].src;
    }
    else
    var from = RemoteRequire.currentPath;

    if( RemoteRequire.map[ src ] )
    {
      RemoteRequire.currentPath = RemoteRequire.map[ src ].realPath;
     try
     {
      res = RemoteRequire.map[ src ].module();
     }
     catch(err)
     {
     }
     return res;
    }

    var obj = { from : from, file : src };
    var advanced  = { method : 'POST', send : JSON.stringify( obj ) };
    var response = _.fileProvider.fileRead({  filePath : 'require', advanced : advanced });
    response = JSON.parse( response );
    if( response.path )
    {
      var _module = _.routineMake({ code : response.file, prependingReturn : 0, usingStrict : 0 } );
      RemoteRequire.map[ src ] = { module : _module, realPath : response.path };
      RemoteRequire.currentPath = RemoteRequire.map[ src ].realPath;
      try
      {
       res = RemoteRequire.map[ src ].module();
      }
      catch(err)
      {
      }
    }
    else
    {
      RemoteRequire.map[ src ] = { module :() => {}, realPath : null };
    }

    return res;
  }

  // --
  // relationship
  // --

  var Restricts =
  {
  }

  var Statics =
  {
    require : require,
    currentPath : null,
    map : {}
  }

  // --
  // prototype
  // --

  var Proto =
  {

    init : init,

    // relationships

    Restricts : Restricts,
    Statics : Statics,

  }

  //

  _.prototypeMake
  ({
    cls : Self,
    parent : Parent,
    extend : Proto,
  });


  _global_[ 'RemoteRequire' ] = Self();
  _global_[ 'require' ] =  _global_[ 'RemoteRequire' ].require.bind( Self );
  _global_[ 'module' ] =  {};
})();
