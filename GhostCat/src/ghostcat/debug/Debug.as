package ghostcat.debug
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.sendToURL;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.util.Util;
	

	/**
	 * 
	 * 辅助类，提供了调试相关的扩展。
	 * Debug.trace()即可使用新的trace。
	 * 
	 * 这只是一个简单实现，复杂项目请使用专门的log框架。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public final class Debug
	{
		/**
		 * 显示的Debug过滤通道列表，设置为null表示全部可以显示。
		 * 这种方法可以避免铺天盖地的trace造成的困扰。
		 */		
		public static var channels:Array;
		
		/**
		 * 是否处于DEBUG模式。系统可借助此属性来切换调试与非调试模式。
		 * 在非调试模式下，将禁用trace。因为自定义trace编译不会被自动删除，此属性对于提高效率是必须的。
		 */		
		public static var DEBUG:Boolean = true;
		
		/**
		 * 记录日志用。实际运行时，可在程序出错后将客户端日志信息发送出去，做为服务端日志的有效补充。 
		 */		
		public static var log:String = "";
				
		/**
		 * 是否激活日志记录 
		 */		
		public static var enabledLog:Boolean = false;
		
		/**
		 * 用来显示TRACE信息的TextField
		 */
		public static var debugTextField:TextField;
		
		/**
		 * 是否激活浏览器控制台trace，信息将会被同时输出到firebug或者Chrome的控制台内。
		 */
		public static var enabledBrowserConsole:Boolean = true;
		
		/**
		 * 是否显示时间
		 */		
		public static var showTime:Boolean = false;
		
		/**
		 * 出错时，日志发送的地址 
		 */		
		public static var logUrl:String;
		
		/**
		 * 出错时，执行的方法
		 */		
		public static var errorHandler:Function = defaultErrorHandler;
		
		/**
		 * 主方法
		 * @param channel	使用的通道，设置为null则表示任何时候都会显示
		 * @return 
		 * 
		 */	
		public static function trace(channel:String, ...rest):void
		{
			var text:String = getHeader(channel)+ (rest as Array).join(",");
			
			if (DEBUG && (channels==null || channel==null || channels.indexOf(channel) != -1))
				traceExt(text);
			
			if (enabledLog)
				log += text+"\n";
				
			if (debugTextField)
				debugTextField.appendText(text+"\n");
				
			if (DEBUG && enabledBrowserConsole && ExternalInterface.available)
				ExternalInterface.call("console.log",text);
				
		}
		
		public static function traceAll(...rest):void
		{
			trace(null,rest);
		}
		
		/**
		 * 显示一个对象的属性
		 * 
		 * @param channel
		 * @param obj
		 * 
		 */
		public static function traceObject(channel:String,obj:Object):void
		{
			var result:String = "";
			for (var key:* in obj)
			{
				if (result.length > 0)
					result += ", ";
				result += key + ":" + obj[key];
			}
			trace(channel,"{"+result+"}");
		}
		
		private static function getHeader(channel:String):String
		{
			var result:String = "";
			if (showTime)
			{
				var date:Date = new Date();
				result = "[" + date.hours +":"+ date.minutes+":"+ date.seconds +":"+ date.milliseconds + "]";
				if (channel)
					result += "[" + channel + "]"
			}
			return result;
		}
		
		/**
		 * 出错时调用，将会将日志发送至服务器
		 * 
		 * @param text 错误信息
		 */		
		public static function error(text:String=null):void
		{
			if (DEBUG && enabledBrowserConsole && ExternalInterface.available)
				ExternalInterface.call("console.error",text);
			
			errorHandler(text);
			
			if (logUrl){
				var values:URLVariables = new URLVariables();
				values.log = log;
				
				var req:URLRequest = new URLRequest(logUrl);
				req.data = values;
				
				sendToURL(req);
				
				log = "";
			}
		}
		
		private static function defaultErrorHandler(text:String):void
		{
			if (text)
				throw new Error(text);
		}
		
		/**
		 * 限定参数的类型并报错
		 * 
		 * @param obj
		 * @param classes
		 * 
		 */
		public static function restriction(obj:*,classes:Array):void
		{
			if (obj == null)
				return;
				
			if (!Util.isIn(obj,classes))
			{
				var arr:Array = [];
				for (var i:int=0;i<classes.length;i++)
					arr.push(getQualifiedClassName(classes[i]))
				
				error("类型必须限定为["+arr.join(",")+"]中的一个");
			}
		}
		
		/**
		 * 判断SWF是否是调试版本
		 * @return 
		 * 
		 */		
		public static function get isDebugSWF():Boolean
		{
			return new Error().getStackTrace().search(/:[0-9]+]$/m) > -1;
		}
		
		/**
		 * 判断是否在网络上
		 * @return 
		 * 
		 */
		public static function get isNetWork():Boolean
		{
			return Security.sandboxType == Security.REMOTE;
		}
		
	}
}
function traceExt(...rest):void{
	trace(rest);
}