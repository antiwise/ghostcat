package org.ghostcat.manager
{
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	
	import org.ghostcat.core.Singleton;
	
	/**
	 * 通过JS与浏览器通讯
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BrowerManager extends Singleton
	{
		[Embed(source = "BrowerManager.js",mimeType="application/octet-stream")]
		private static var jsCode:Class;
		ExternalInterface.available && ExternalInterface.call("eval",new jsCode().toString());
		
		static public function get instance():BrowerManager
		{
			return Singleton.getInstanceOrCreate(BrowerManager) as BrowerManager;
		}
		
		/**
		 * 浏览器完整地址
		 * @return 
		 * 
		 */
		public function get url():String
        {
        	return ExternalInterface.call("BrowerManager.getURL");
        };
        /**
         * 浏览器除去参数后的地址
         * @return 
         * 
         */        
        public function get baseUrl():String
        {
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
        	ExternalInterface.call("BrowerManager.setTitle",v);
        };
        public function get title():String
        {
        	return ExternalInterface.call("BrowerManager.getTitle");
        };
        /**
         * 浏览器地址栏参数
         * @param values
         * 
         */        
        public function set urlVariables(values:URLVariables):void
        {
        	var url:String = "";
        	var para:String = values.toString();
        	if (para.length>0)
        	 	url += "#" + para;
        	
        	ExternalInterface.call("BrowerManager.setUrlVariables",url);
        }
        public function get urlVariables():URLVariables
        {
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
        public function setCookie(name:String, value:String, expires:Date, security:Boolean):void
        {
        	ExternalInterface.call("BrowerManager.setCookie",name,value,expires.toUTCString(),security);
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
        	return ExternalInterface.call("BrowerManager.getCookie",name);
        }
	}
}



