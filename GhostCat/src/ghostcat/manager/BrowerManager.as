package ghostcat.manager
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import ghostcat.util.core.Singleton;
	
	/**
	 * 通过JS与浏览器通讯
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BrowerManager extends EventDispatcher
	{
		[Embed(source = "BrowerManager.js",mimeType="application/octet-stream")]
		private static var jsCode:Class;
		ExternalInterface.available && ExternalInterface.call("eval",new jsCode().toString());
		
		static private var _instance:BrowerManager;
		static public function get instance():BrowerManager
		{
			if (!_instance)
				_instance = new BrowerManager();
			
			return _instance;
		}
		
		/**
		 * 浏览器完整地址
		 * @return 
		 * 
		 */
		public function get url():String
        {
			if (!ExternalInterface.available) 
				return null;
			
        	return ExternalInterface.call("BrowerManager.getURL");
		};
        /**
         * 浏览器除去参数后的地址
         * @return 
         * 
         */        
        public function get baseUrl():String
        {
			if (!ExternalInterface.available) 
				return null;
			
			var url:String = this.url;
        	var p:int = url.indexOf("#");
        	if (p>0)
        		return url.substr(0,p - 1);
        	else
        		return url;
        }
        /**
         * 浏览器标题
         * @param v
         * 
         */        
        public function set title(v:String):void
        {
			if (!ExternalInterface.available) 
				return;
			
			ExternalInterface.call("BrowerManager.setTitle",v);
        };
        public function get title():String
        {
			if (!ExternalInterface.available) 
				return null;
			
			return ExternalInterface.call("BrowerManager.getTitle");
        };
        /**
         * 浏览器地址栏参数
         * @param values
         * 
         */        
        public function set urlVariables(values:URLVariables):void
        {
			if (!ExternalInterface.available) 
				return;
			
			var url:String = "";
        	var para:String = values.toString();
        	if (para.length>0)
        	 	url += "#" + para;
        	
        	ExternalInterface.call("BrowerManager.setUrlVariables",url);
        }
        public function get urlVariables():URLVariables
        {
			if (!ExternalInterface.available) 
				return null;
			
			var url:String = this.url;
        	var p:int = url.indexOf("#");
        	if (p>0)
        		return new URLVariables(url.substr(p + 1));
        	else
        		return new URLVariables();
        }
        /**
         * 加入收藏夹 
         * @param url
         * @param title
         * 
         */        
        public function addFavorite(title:String=null,url:String=null):void
        {
			if (!ExternalInterface.available) 
				return;
			
			if (!url)
        		url = this.url;
        	
        	if (!title)
        		title = this.title;
        		
        	ExternalInterface.call("BrowerManager.addFavorite",url,title);
        }
        /**
         * 设为主页
         * @param url
         * 
         */        
        public function setHomePage(url:String=null):void
        {
			if (!ExternalInterface.available) 
				return;
			
			if (!url)
        		url = this.url;
        		
        	ExternalInterface.call("BrowerManager.setHomePage",url);
        }

		/**
         * 设置cookie
         * 
         * @param name           cookie名称
		 * @param value          cookie值
		 * @param expires        cookie过期时间
		 * @param security       是否加密
         */
        public function setCookie(name:String, value:String, expires:Date=null, security:Boolean=false):void
        {
			if (!ExternalInterface.available) 
				return;
			
			expires || (expires = new Date(new Date().time + (1000 * 86400 * 365)));
        	ExternalInterface.call("BrowerManager.setCookie",name,value,expires.time,security);
        }
        
        /**
         * 读取cookie
         * 
         * @param name	cookie名称
         * @return 
         * 
         */        
        public function getCookie(name:String):String
        {
			if (!ExternalInterface.available) 
				return null;
			
			return ExternalInterface.call("BrowerManager.getCookie",name);
        }
        
        /**
         * 在浏览器关闭时提供确认提示
         * 
         */
        public function confirmClose(text:String = "确认退出？"):void
        {
			if (!ExternalInterface.available)
				return;
			
			if (text)
        		ExternalInterface.call("BrowerManager.confirmClose",text);
			else
				ExternalInterface.call("BrowerManager.confirmClose");
			
		}
		
		/**
		 * 弹出警示框
		 * @param text
		 * 
		 */
		public function alert(...params):void
		{
			if (!ExternalInterface.available) 
				return;
			
			ExternalInterface.call("alert",params.toString());
		}
		
		/**
		 * 刷新浏览器 
		 * 
		 */
		public function reload():void
		{
			if (!ExternalInterface.available) 
				return;
			
			ExternalInterface.call("location.reload");
		}
		
		/**
		 * 消除浏览器的滚动事件干扰 
		 * 
		 */
		public function disableScroll(objId:String = null):void
		{
			if (!ExternalInterface.available) 
				return;
			
			ExternalInterface.call("BrowerManager.disableScroll",objId);
		}
		
		/**
		 * 打开地址（支持javascript:写法）
		 * 
		 * @param url
		 * @return 
		 * 
		 */
		public function getUrl(url:String,target:String = "_self"):void
		{
			if (url.substr(0,11) == "javascript:" && ExternalInterface.available)
			{
				var js:String = url.substr(11);
				if (url.indexOf("(") == -1 && url.indexOf(")") == -1)
					js += "()";
				
				ExternalInterface.call("eval",js);
			}
			else
			{
				navigateToURL(new URLRequest(url),target);
			}
		}
	}
}



