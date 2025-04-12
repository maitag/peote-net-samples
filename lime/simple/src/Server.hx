package;

import haxe.io.Bytes;
import peote.net.PeoteServer;

class Server extends lime.app.Application
{	
	var host:String = "localhost";
	var port:Int = 7680;
	var channelName = "testChannel";
	
	public function new()
	{
		super();

		trace("----------- START SERVER -----------");
		
		var peoteServer = new PeoteServer(
		{
			onCreate: function(server:PeoteServer)
			{
				trace('SERVER -> onCreateJoint: Channel ${server.jointNr} created.');
			},
			
			onUserConnect: function(server:PeoteServer, userNr:Int)
			{
				trace('SERVER -> onUserConnect: jointNr:${server.jointNr}, userNr:$userNr');
			},
			
			onData: function(server:PeoteServer, userNr:Int, data:Bytes)
			{
				trace('SERVER -> onData: jointNr:${server.jointNr}, userNr:$userNr');				
			},
			
			onUserDisconnect: function(server:PeoteServer, userNr:Int, reason:Int)
			{
				trace('SERVER -> onUserDisconnect: jointNr:${server.jointNr}, userNr:$userNr');
			},
			
			onError: function(server:PeoteServer, userNr:Int, reason:Int)
			{
				trace('SERVER -> onCreateJointError:$reason, userNr:$userNr');
			}
			
		});
				
		// create server
		peoteServer.create(host, port,channelName);
		
	}
		
}
