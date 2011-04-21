package ghostcat.display.loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.fileformat.swf.SWFDecoder;
	
	/**
	 * 由此类加载的外部SWF将会播放时将使用原始帧频，并自动转换成位图序列
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapMovieClipLoader extends GBitmapMovieClip
	{
		/**
		 * 渲染区域 
		 */
		public var renderRect:Rectangle;
		
		/**
		 * 是否在播放时顺便缓存
		 */
		public var readWhenPlaying:Boolean = false;
		
		/**
		 * 每次缓存允许的最高时间
		 */
		public var limitTimeInFrame:int = 10;
		
		public var loader:URLLoader;
		public var swf:SWFDecoder;
		public function GBitmapMovieClipLoader(request:URLRequest, renderRect:Rectangle = null, paused:Boolean=false)
		{
			this.renderRect = renderRect;
			
			super(null,null, paused);
			
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
		
		protected function loadCompleteHandler(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			
			var bytes:ByteArray = loader.data as ByteArray;
			
			var swfLoader:Loader = new Loader();
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfLoadCompleteHandler);
			swfLoader.loadBytes(bytes);
			
			swf = new SWFDecoder();
			swf.read(bytes,false);
			this.frameRate = swf.frameRate;
			
		}
		
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		protected function swfLoadCompleteHandler(event:Event):void
		{
			var loadInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			loadInfo.removeEventListener(Event.COMPLETE,swfLoadCompleteHandler);
			createFromMovieClip(loadInfo.loader.content as MovieClip,renderRect,1,-1,readWhenPlaying,limitTimeInFrame);
		}
	}
}