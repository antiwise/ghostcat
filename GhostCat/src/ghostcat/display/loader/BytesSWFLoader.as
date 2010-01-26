package ghostcat.display.loader
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	/**
	 * 采用非流的方式加载SWF动画 
	 * @author flashyiyi
	 * 
	 */
	public class BytesSWFLoader extends EventDispatcher
	{
		protected var loader:Loader;
		protected var urlLoader:URLLoader;
		
		private var context:LoaderContext;
		
		public function get content():DisplayObject
		{
			return loader ? loader.content : null;
		}
		
		public function BytesSWFLoader()
		{
			super();
		}
		
		public function load(url:URLRequest,context:LoaderContext = null):void
		{
			this.context = context;
			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE,urlLoaderComplete);
			urlLoader.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorComplete);
				
			urlLoader.load(url);
		}
		
		private function urlLoaderComplete(event:Event):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			loader.loadBytes((event.currentTarget as URLLoader).data as ByteArray,context);
		}
		
		private function ioErrorComplete(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		private function completeHandler(event:Event):void
		{
			dispatchEvent(event);
		}
	}
}