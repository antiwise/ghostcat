package ghostcat.display.loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.events.TickEvent;
	import ghostcat.fileformat.swf.SWFDecoder;
	
	/**
	 * 由此类加载的外部SWF将会播放时将使用原始帧频
	 * @author flashyiyi
	 * 
	 */
	public class GMovieClipLoader extends GMovieClip
	{
		public var loader:URLLoader;
		public var swf:SWFDecoder;
		public var useAssetFrameRate:Boolean = true;
		public function GMovieClipLoader(request:URLRequest=null, paused:Boolean=false)
		{
			super(null, replace, paused);
			
			this.acceptContentPosition = false;
			
			if (request)
				load(request);
		}
		
		public function load(request:URLRequest):void
		{
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			loader.load(request);
		}
		
		public function unload():void
		{
			setContent(null);
		}
		
		protected function loadCompleteHandler(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			
			var bytes:ByteArray = loader.data as ByteArray;
			
			var swfLoader:Loader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfLoadCompleteHandler);
			swfLoader.loadBytes(bytes);
			
			if (useAssetFrameRate)
			{
				swf = new SWFDecoder();
				swf.read(bytes,false);
				this.frameRate = swf.frameRate;
			}
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		protected function swfLoadCompleteHandler(event:Event):void
		{
			var loadInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			loadInfo.removeEventListener(Event.COMPLETE,swfLoadCompleteHandler);
			setContent(loadInfo.loader.content);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}