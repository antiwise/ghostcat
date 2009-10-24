package ghostcat.extend
{
	import flash.external.ExternalInterface;
	
	/**
	 * 调用JS实现的音乐播放器
	 * 
	 * 它可以不受沙箱限制播放各种音频（mid,mp3,wmv,rm），以及实时音频流（rstp,mms），
	 * 将会受到浏览器以及已安装的浏览器插件影响
	 * 
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
		
		/**
		 * 设置音量
		 * @param v
		 * 
		 */
		public static function setVolume(v:Number):void
		{
			ExternalInterface.call("setVolume("+v.toString()+")");
		}
	}
}