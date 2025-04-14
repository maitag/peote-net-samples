package;

import haxe.Timer;
import haxe.io.Bytes;
import peote.net.PeoteClient;
import peote.net.Reason;

class Client extends lime.app.Application
{
	var host:String = "localhost";
	var port:Int = 7680;

	var channelName = "testChannel";

	var peoteClient:PeoteClient;
	
	public function new()
	{
		super();
		
		trace("----------- START CLIENT -----------");
		
		peoteClient = new PeoteClient(
		{
			onEnter: function(client:PeoteClient) {
				trace('CLIENT -> onEnterJoint: Joint number ${client.jointNr} entered');
			},
			
			onData: function(client:PeoteClient, data:Bytes) {
				trace('CLIENT -> onData: jointNr:${client.jointNr}, data:${data}');

				Timer.delay(()-> {
					peoteClient.send( Bytes.ofString("PING") );
				}, 1000);		
			},
			
			onDisconnect: function(client:PeoteClient, reason:Int) {
				trace('CLIENT -> onDisconnect: jointNr=${client.jointNr}');
			},
			
			onError: function(client:PeoteClient, reason:Int) {
				switch(reason) {
					case Reason.DISCONNECT:trace("CLIENT -> Can't connect to peote-server.");
					case Reason.CLOSE:     trace("CLIENT -> Connection to peote-server is closed.");
					case Reason.ID:        trace("CLIENT -> No channel with this ID to enter.");
					case Reason.MAX:       trace("CLIENT -> Entered to much channels on this server at the same time (max is 128)");
					case Reason.FULL:      trace("CLIENT -> Channel is full (max of 256 users already connected).");
					case Reason.MALICIOUS: trace("CLIENT -> Malicious data.");
				}
			}			
		});		
		
		// enter server
		peoteClient.enter(host, port, channelName);
		
	}
		
}
