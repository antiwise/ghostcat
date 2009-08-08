package org.ghostcat.manager
{
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	
	import org.ghostcat.core.Singleton;
	
	public class BrowerManager extends Singleton
	{
		static public function get instance():BrowerManager
		{
			return Singleton.getInstanceOrCreate(BrowerManager) as BrowerManager;
		}
		
		protected function runJSCode(code:String , ...para):*
		{
			if (ExternalInterface.available)
				return ExternalInterface.call.apply(null,[code].concat(para));
		}
		
		/**
		 * 浏览器完整地址
		 * @return 
		 * 
		 */
		public function get url():String
        {
        	return runJSCode(
			"function (url){" + 
			"	return document.location.href;" + 
			"}");
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
        	runJSCode(
			"function (title){" + 
			"	document.title = title;" + 
			"}"
			,v);
        };
        public function get title():String
        {
        	return runJSCode(
			"function (){" + 
			"	return document.title;" + 
			"}");
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
        	runJSCode(
			"function (url){" + 
			"	window.location.replace(url);" + 
			"}",url);
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
        public function addFavorite(url:String=null,title:String=null):void
        {
        	if (!url)
        		url = this.url;
        	runJSCode(
        	"function (url,title){"+
        	"	window.external.AddFavorite(url, title);"+
        	"}"
        	,url,title);
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
        	runJSCode(
        	"function (url){" + 
        	"	this.style.behavior='url(#default#homepage)';" + 
        	"	this.setHomePage(url);" +
        	"}"
        	,url);
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
        	runJSCode(
        	"function (name, value, expires, security) {" +
			"	var str = name + '=' + escape(value);" +
			"	if (expires != null) str += ';expires=' + expires" +
			"	if (security == true) str += ';secure';" +
			"	document.cookie = str;" +
			"}"
			,name,value,expires.toUTCString(),security);
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
        	return runJSCode(
        	"function (name) {" +
			"	var arr = document.cookie.match(new RegExp(';?' +name + '=([^;]*)'));" +
			"	if(arr != null) return unescape(arr[1]);" +
			"	return null;" + 
			"}"
			,name);
        }
	}
}



