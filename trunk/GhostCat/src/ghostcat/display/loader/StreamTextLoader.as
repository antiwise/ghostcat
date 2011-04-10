package ghostcat.display.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import ghostcat.ui.controls.GText;
	
	/**
	 * 渐进式加载文本
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class StreamTextLoader extends TextField
	{
		/**
		 * 文本编码 
		 */
		public var charSet:String="utf-8";
		
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
		
		private var prevRefreshTime:int = 500;
		
		public function StreamTextLoader(request:URLRequest = null)
		{
			super();
			
			stream = new URLStream();
			stream.addEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.addEventListener(Event.COMPLETE,completeHandler);
			
			if (request)
				load(request);
		}
		
		/**
		 * 加载 
		 * @param request
		 * 
		 */
		public function load(request:URLRequest):void
		{
			loadComplete = false;
			
			bytes = new ByteArray();
			stream.load(request);
			
			prevRefreshTime = getTimer();
		}
		
		/**
		 * 加载器 
		 * @return 
		 * 
		 */
		public function get eventDispatcher():EventDispatcher
		{
			return stream;
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
				text = bytes.readMultiByte(bytes.bytesAvailable,charSet);
				prevRefreshTime = getTimer();
			}
		}
		
		private function completeHandler(event:Event):void
		{
			refreshFun(true);
			loadComplete = true;
			
			stream.removeEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.removeEventListener(Event.COMPLETE,completeHandler);
			stream.close();
			stream = null;
			bytes = null;
		}
	}
}