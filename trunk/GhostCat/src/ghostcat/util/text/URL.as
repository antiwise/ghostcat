package ghostcat.util.text
{
	import flash.net.URLVariables;
	
	import ghostcat.util.Util;

	/**
	 * URL解析
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class URL
	{
		public static function isHTTP(v:String):Boolean
		{
			return v.substr(0,7).toLowerCase() == "http://";
		}
		
		/**
		 * 使用的正则
		 */
		public const regex:RegExp = /^((\w+):\/{2,3})?((\w+):?(\w+)?@)?([^\/\?:]+):?(\d+)?(\/?[^\?#]+)?\??([^#]+)?#?(\w*)/; 
 		
 		/**
		 * 协议名（诸如http）
		 */
		public var protocol:String;
    	
    	/**
		 * 主机名（诸如www.google.com）或者文件系统中的盘符
		 */
		public var host:String;
    	
    	/**
		 * 端口号 
		 */
		public var port:int;
		
		/**
		 * 除去主机名后的路径
		 */
		public var pathname:FilePath;
		
		/**
		 * URL中的用户名
		 */
		public var username:String;
		
		/**
		 * URL中的密码
		 */
		public var password:String;
		
		/**
		 * 参数列表
		 */
		public var queryString:URLVariables;
		
		/**
		 * 锚点
		 */
		public var fragment:String;
    	
		/**
		 * 
		 * @param v
		 * @param hasPath	是否拥有路径名
		 * 
		 */
    	public function URL(v:String,hasPath:Boolean = true)
		{
			if (!v)
				v = "";
			
			var data:Array = regex.exec(v);
			protocol = data[2];
			username = data[4];
			password = data[5];
			host = data[6];
			port = data[7];
			pathname = data[8] ? new FilePath(data[8]) : null;
			queryString = data[9] ? new URLVariables(data[9]) : null;
			fragment = data[10];
			
			if (hasPath && !pathname && host)//只有文件名的时候将会产生混淆，取host的值
			{
				pathname = new FilePath(host);
				host = null;
			}
		}
		
		public function toString():String
		{
			var result:String = "";
			if (protocol)
			{
				result += protocol + "://";
				if (protocol == "file")
					result += "/";
			}
			if (username && password)
				result += username + ":" + password + "@";	
			
			if (host)
			{
				result += host;
				if (protocol == "file")
					result += ":";
			}
			
			if (port)
				result += ":" + port.toString();
			
			if (pathname)
				result += "/" + pathname.toString();
			
			if (queryString)
				result += "?" + queryString.toString();
			
			if (fragment)
				result += "#" + fragment;
			
			return result;
		}
	}
}