package ghostcat.display.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	/**
	 * 渐进式加载图片
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class StreamLoader extends Loader
	{
		/**
		 * 载入完毕
		 */
		public var loadComplete:Boolean = false;
		
		public var stream:URLStream;
		private var bytes:ByteArray;
		
		public function StreamLoader(request:URLRequest = null)
		{
			if (request)
				load(request);
		}
		
		public function streamLoad(request:*):void
		{
			loadComplete = false;
			
			if (!request)
				return;
			
			if (request is String)
				request = new URLRequest(request);
			
			bytes = new ByteArray();
			
			stream = new URLStream();
			stream.addEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.addEventListener(Event.COMPLETE,completeHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			stream.load(request);
		}
		
		private function refreshProgress(event:Event):void
		{
			var loader:Loader = content as Loader;
			stream.readBytes(bytes,bytes.length);
			if (bytes.length > 0)
			{
				loader.unload();
				loader.loadBytes(bytes);
			}
		}
		
		private function completeHandler(event:Event):void
		{
			refreshProgress(event);
			
			loadComplete = true;
			
			stream.removeEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.removeEventListener(Event.COMPLETE,refreshProgress);
			stream.close();
			stream = null;
			
			bytes = null;
		}
		
		private function errorHandler(event:IOErrorEvent):void
		{
			stream.close();
			stream = null;
			
			bytes = null;
		}
	}
}