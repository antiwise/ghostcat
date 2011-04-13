package ghostcat.fileformat.swf
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 获得执行者自身的SWF数据
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SWFSelf extends EventDispatcher
	{
		/**
		 * SWF的二进制数据
		 */
		public var data:ByteArray;
		
		/**
		 * 调用成功回调函数，参数为data
		 */
		public var rhandler:Function;
		private var loader:URLLoader;
		
		/**
		 * 
		 * @param obj	舞台对象
		 * @param rhandler	调用成功回调函数
		 * 
		 */
		public function SWFSelf(obj:DisplayObject,rhandler:Function)
		{
			this.rhandler = rhandler;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,completeHandler);
			loader.load(new URLRequest(obj.loaderInfo.url));
		}
		
		private function completeHandler(event:Event):void
		{
			data = loader.data as ByteArray;
			
			loader.removeEventListener(Event.COMPLETE,completeHandler);
			loader = null;
			
			if (rhandler!=null)
				rhandler(data);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}