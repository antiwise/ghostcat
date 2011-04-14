package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import ghostcat.operation.LoadOper;
	import ghostcat.operation.server.SocketDataCreater;
	
	[SWF(frameRate="25",width="1000",height="1000")]
	public class Test extends Sprite 
	{
		
		public function Test()
		{
			trace(0xEF,0xBB,0xBF);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,h);
			loader.load(new URLRequest("ui.lang"));
			function h(e:Event):void
			{
				var str:String = loader.data;
				trace(str.charCodeAt(0));
			}
		}
		
	}
}