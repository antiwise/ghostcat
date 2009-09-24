package ghostcat.display.loader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	
	import ghostcat.ui.controls.GText;
	
	/**
	 * 渐进式加载文本
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class StreamTextLoader extends GText
	{
		public var charSet:String="utf-8";
		/**
		 * 载入完毕
		 */
		public var loadComplete:Boolean = false;
		
		private var stream:URLStream;
		
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
			stream.load(request);
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
			text = text + stream.readMultiByte(stream.bytesAvailable,charSet);
		}
		
		private function completeHandler(event:Event):void
		{
			refreshProgress(event);
			loadComplete = true;
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			super.destory();
			
			stream.removeEventListener(ProgressEvent.PROGRESS,refreshProgress);
			stream.removeEventListener(Event.COMPLETE,refreshProgress);
			stream.close();
		}
	}
}