package ghostcat.display.loader
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextField;

	/**
	 * 加载器生成类 
	 * @author flashyiyi
	 * 
	 */
	public final class LoaderCreater
	{
		/**
		 * 获得一个Loader
		 * @param url
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */
		public static function getLoader(url:*,width:Number = NaN,height:Number = NaN):Loader
		{
			var loader:Loader = new Loader();
			var request:URLRequest;
			if (url is URLRequest)
				request = url as URLRequest;
			else
				request = new URLRequest(url);
			
			loader.load(request, new LoaderContext(true));
			if (!isNaN(width) || !isNaN(height))
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			return loader;
			
			function loadCompleteHandler(event:Event):void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadCompleteHandler);
				if (!isNaN(width))
					loader.content.width = width;
				if (!isNaN(height))
					loader.content.height = height;
			}
		}
		
		/**
		 * 获得一个显示文字的文本框 
		 * @param url
		 * @param html	是否是html文本
		 * @return 
		 * 
		 */
		public static function getTextField(url:*,html:Boolean = false):TextField
		{
			var loader:URLLoader = new URLLoader();
			var textField:TextField = new TextField();
			var request:URLRequest;
			if (url is URLRequest)
				request = url as URLRequest;
			else
				request = new URLRequest(url);
			
			loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
			return textField;
			
			function loadCompleteHandler(event:Event):void
			{
				loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
				if (html)
					textField.htmlText = loader.data;
				else
					textField.text = loader.data;
			}
		}
	}
}