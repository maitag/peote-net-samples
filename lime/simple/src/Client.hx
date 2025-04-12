package;

import haxe.io.Bytes;
import peote.net.PeoteClient;

class Client extends lime.app.Application
{
	var host:String = "localhost";
	var port:Int = 7680;
	var channelName = "testChannel";
	
	public function new()
	{
		super();
		
		trace("----------- START CLIENT -----------");
		
		var peoteClient = new PeoteClient(
		{
			onEnter: function(client:PeoteClient)
			{
				trace('CLIENT -> onEnterJoint: Joint number ${client.jointNr} entered');
			},
			
			onData: function(client:PeoteClient, data:Bytes)
			{
				trace('CLIENT -> onData: jointNr:${client.jointNr}, data:${data}');
			},
			
			onDisconnect: function(client:PeoteClient, reason:Int)
			{
				trace('CLIENT -> onDisconnect: jointNr=${client.jointNr}');
			},
			
			onError: function(client:PeoteClient, reason:Int)
			{
				trace('CLIENT -> onEnterJointError:$reason');
			}
			
		});		
		
		// enter server
		peoteClient.enter(host, port, channelName);
		
	}
		
}
