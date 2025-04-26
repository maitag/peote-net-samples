package;

import haxe.Timer;
import haxe.io.Bytes;
import peote.net.PeoteServer;
import peote.net.Reason;

class Server extends lime.app.Application
{	
	var host:String = "localhost";
	var port:Int = 7680;

	var channelName = "testChannel";

	var peoteServer:PeoteServer;
	
	public function new()
	{
		super();

		trace("----------- START SERVER -----------");
		
		peoteServer = new PeoteServer(
		{
			onCreate: function(server:PeoteServer) {
				trace('SERVER -> onCreateJoint: Channel ${server.jointNr} created.');
			},
			
			onUserConnect: function(server:PeoteServer, userNr:Int) {
				trace('SERVER -> onUserConnect: jointNr:${server.jointNr}, userNr:$userNr');

				peoteServer.send(userNr, Bytes.ofString("PONG")); // initial pong

				// send to all connected users
				peoteServer.broadcast( Bytes.ofString('NEW USER CONNECTED'));

				// send to all connected users out of userNr itself
				peoteServer.broadcast( Bytes.ofString('userNr:$userNr connected to server'), userNr);
			},
			
			onData: function(server:PeoteServer, userNr:Int, data:Bytes) {
				trace('SERVER -> onData: jointNr:${server.jointNr}, userNr:$userNr, data:${data}');

				Timer.delay(()-> {
					peoteServer.send(userNr, Bytes.ofString("PONG"));
				}, 1000);		
			},
			
			onUserDisconnect: function(server:PeoteServer, userNr:Int, reason:Reason) {
				trace('SERVER -> onUserDisconnect: jointNr:${server.jointNr}, userNr:$userNr, reason:Sreason');
			},
			
			onError: function(server:PeoteServer, userNr:Int, reason:Reason) {
				switch(reason) {
					case DISCONNECT:trace("SERVER -> Can't connect to peote-server.");
					case CLOSE:     trace("SERVER -> Connection to peote-server is closed.");
					case ID:        trace("SERVER -> There is another channel with same ID. (or wrong ID)");
					case MAX:       trace("SERVER -> Created to much channels on this server at the same time (max is 128).");
					case MALICIOUS: trace('SERVER -> User $userNr sending malicious data.');
					default: trace(reason);
				}
			}			
		});
				
		// create server
		peoteServer.create(host, port,channelName);
		
	}
		
}
