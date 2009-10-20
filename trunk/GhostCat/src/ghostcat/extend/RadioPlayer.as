package ghostcat.extend
{
	import flash.external.ExternalInterface;
	
	/**
	 * 调用JS实现的音乐播放器
	 * @author flashyiyi
	 * 
	 */
	public class RadioPlayer
	{
		[Embed(source = "bgradio.js",mimeType="application/octet-stream")]
		private static var jsCode:Class;
		ExternalInterface.available && ExternalInterface.call("eval",new jsCode().toString());
		
		/**
		 * 播放
		 * @param url
		 * 
		 */
		public static function play(url:String):void
		{
			ExternalInterface.call("radioPlay('"+url+"')");
		}
		
		/**
		 * 停止
		 * 
		 */
		public static function stop():void
		{
			ExternalInterface.call("radioStop()");
		}	
	}
}