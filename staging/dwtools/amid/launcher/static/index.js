var _ = wTools;
_.io = io;
var __launcher__ =
(function ()
{
  var self = this;

  self.request = function( url, onResponse )
  {
      var xmlHttp = new XMLHttpRequest();
      xmlHttp.onreadystatechange = function ()
      {
        if ( xmlHttp.readyState == 4 && xmlHttp.status == 200 )
        onResponse( xmlHttp.responseText );
      }
      xmlHttp.open( "GET", url, true );
      xmlHttp.send( null );
  }

  self.getScript = function ()
  {
    var con = new wConsequence();
    self.parsedUrl = _.urlParse( window.location.href );
    var requestUrl = _.urlJoin( self.parsedUrl.origin, 'script' )
    self.request( requestUrl, function ( data )
    {
       self.script = _.routineMake({ code : data, prependingReturn : 0 } );
       con.give();
    })

    return con;
  }

  //

  self.run = function ()
  {
    return self.getScript()
    .doThen( function ()
    {
      wLogger.rawOutput = true;
      self.loggerToServer = new wLoggerToServer();
      self.loggerToServer.permanentStyle = { bg : 'yellow', fg : 'black' };
      self.loggerToServer.inputFrom( console );
    })
    .doThen( () => self.loggerToServer.connect() )
    .doThen( () => self.script() )
    .doThen( () => self.terminate() )
  }

  //

  self.terminate = function ()
  {
    var con = self.loggerToServer.disconnect();
    con.got( function ()
    {
      var requestUrl = _.urlJoin( self.parsedUrl.origin, 'terminate' );
      self.request( requestUrl, () => con.give() );
    })

   return con;
  }

  return self;
})();

__launcher__.run();

// var script;
// var port;

// var url = 'http://localhost:' + port;
// wLogger.rawOutput = true;
// var l = new wLoggerToServer();
// l.permanentStyle = { bg : 'yellow', fg : 'black' };
// // wLogger.consoleBar
// // ({
// //   outputLogger : l,
// //   bar : 1
// // });
// l.inputFrom( console );
// l.connect()
// .doThen( () => script() )
// .doThen( () => l.disconnect() )
// .doThen( function ()
// {
//   var socket = _.io( url );
//   socket.on( 'connect', function()
//   {
//     socket.emit( 'terminate', '' );
//     socket.disconnect();
//   });
// });
