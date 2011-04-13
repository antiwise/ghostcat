package ghostcat.display.loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * 此方法加载的图片将无视沙箱 
	 * @author flashyiyi
	 * 
	 */
	public class ImageLoader extends Loader
	{
		private var loader:Loader;
		public function get imageLoadInfo():LoaderInfo
		{
			return loader ? loader.contentLoaderInfo : null;
		}
		
		public function ImageLoader()
		{
			super();	
		}
		
		public override function load(request:URLRequest, context:LoaderContext=null):void
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.load(request, context);
		}
		
		private function removeHandler():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader = null;
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			removeHandler();
			loadBytes((event.currentTarget as LoaderInfo).bytes);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			removeHandler();
			contentLoaderInfo.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
	}
}