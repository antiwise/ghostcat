package ghostcat.display.loader
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/**
	 * 渐进式加载图片
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class StreamLoader extends Sprite
	{
		/**
		 * 载入完毕
		 */
		public var loadComplete:Boolean = false;
		
		/**
		 * 加载的数据 
		 */
		public var bytes:ByteArray;
		
		/**
		 * 数据流 
		 */
		public var stream:URLStream;
		
		/**
		 * 更新间隔
		 */
		public var refreshInv:int = 0;
		
		private var loader:Loader;
		private var prevRefreshTime:int = 500;
		
		public function StreamLoader(request:URLRequest = null)
		{
			if (request)
				load(request);
		}
		
		public function load(request:URLRequest):void
		{
			loadComplete = false;
			
			stream = new URLStream();
			stream.addEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.addEventListener(Event.COMPLETE,completeHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			stream.load(request);
			
			bytes = new ByteArray();
			prevRefreshTime = getTimer();
		}
		
		private function refreshProgress(event:Event):void
		{
			refreshFun();
		}
		
		private function refreshFun(isEnd:Boolean = false):void
		{
			if (isEnd || getTimer() - prevRefreshTime >= refreshInv)
			{
				stream.readBytes(bytes,bytes.length);
				
				bytes.position = 0;
				if (loader)
				{
					removeChild(loader);
					loader.unload();
				}
				loader = new Loader();
				addChild(loader);
				loader.loadBytes(bytes);
				
				prevRefreshTime = getTimer();
			}
		}
		
		private function completeHandler(event:Event):void
		{
			refreshFun(true);
			
			loadComplete = true;
			
			stream.removeEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.removeEventListener(Event.COMPLETE,completeHandler);
			stream.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			stream.close();
			stream = null;
			
			bytes = null;
		}
		
		private function errorHandler(event:IOErrorEvent):void
		{
			stream.removeEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.removeEventListener(Event.COMPLETE,completeHandler);
			stream.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			stream.close();
			stream = null;
			
			bytes = null;
		}
	}
}