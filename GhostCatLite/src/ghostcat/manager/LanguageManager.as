package ghostcat.manager
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.LoadOper;
	import ghostcat.operation.Queue;
	import ghostcat.operation.load.QueueLoadOper;
	import ghostcat.util.text.RegExpUtil;
	import ghostcat.util.text.URL;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.core.Singleton;
	import ghostcat.util.display.SearchUtil;
	
	
	/**
	 * 多语言支持
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class LanguageManager extends EventDispatcher
	{
		static private var _instance:LanguageManager;
		static public function get instance():LanguageManager
		{
			if (!_instance)
				_instance = new LanguageManager();
			
			return _instance;
		}
		
		/**
		 * getString是最常用的方法，移到静态方法里方便调用
		 */		
		static public function getString(res:String,parms:Array=null,args:Array = null):String
		{
			return instance.getString(res,parms,args)
		}
		
		/**
		 * 文件默认路径
		 */
		public var assetBase:String = "";
		
		/**
		 * 自定义转换器，键为{}内部的文字，值为文字属性或者函数。
		 * 当字符串以#开头时，会将其余部分作为ReflectManager.evel()的参数传入，获得其返回值。
		 * 这样一来，就可以方便地进行扩展。最普通的例子，就是自动转换玩家用户名以及性别的显示。
		 */		
		public var customConversion:Object = new Object();
		
		private var resource:Object = new Object();
		
		/**
		 * 自动更新GText内的语言文本
		 * 
		 */		
		public function set registerGText(v:Boolean):void
		{
			GText.textChangeHandler = v ? getString : null;
		}
		
		public function get registerGText():Boolean
		{
			return GText.textChangeHandler == getString;
		}
		
		public function LanguageManager():void
		{
			super();
			this.registerGText = true;
		}
		
		/**
		 * 加载语言包。properties文件的格式和FLEX的多语言相同，主要为了利用IDE的代码分色。详情请参考FLEX帮助。
		 * 注意，此方法可多次使用。
		 * 
		 * @param url	语言文件路径
		 * @param embedClass	备用数据
		 * 可以用[Embed(source="xxx.properties",mimeType="application/octet-stream"))]这类方式嵌入到SWF中
		 * @return 
		 * 
		 */		
		public function load(url:String,embedClass:Class=null,queue:Queue=null):LoadOper
		{
			var loader:LoadOper = new LoadOper(assetBase + url,embedClass,completeHandler);
			loader.commit(queue);
			return loader;
		}
		
		/**
		 * 同时加载多个语言包 
		 * @param urls
		 * @param queueLimit
		 * @param queue
		 * @return 
		 * 
		 */
		public function loadMuit(urls:Array,queueLimit:int = 5,queue:Queue = null):QueueLoadOper
		{
			var loader:QueueLoadOper = new QueueLoadOper(assetBase);
			loader.queueLimit = queueLimit;
			loader.addEventListener(OperationEvent.OPERATION_COMPLETE,muitCompleteHandler);
			loader.loadResources(urls);
			loader.commit(queue);
			return loader;
		}
		
		private function muitCompleteHandler(event:Event):void
		{
			var oper:QueueLoadOper = event.currentTarget as QueueLoadOper;
			oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,muitCompleteHandler)
			for each (var child:LoadOper in oper.opers)
			{
				var url:URL = new URL(child.request.url);
				add(url.pathname.filename,child.data.toString());
			}
		}
		
		private function completeHandler(event:Event):void
		{
			var oper:LoadOper = event.currentTarget as LoadOper;
			oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,completeHandler)
				
			var url:URL = new URL(oper.request.url);
			add(url.pathname.filename,oper.data.toString())
		}
		
		/**
		 * 增加多语言文本
		 *  
		 * @param textType	类别
		 * @param text	内容
		 * 
		 */
		public function add(textType:String,text:String):void
		{
			resource[textType] = {};
			
			//消除文件头
			if (text.charCodeAt(0) == 65279)
				text = text.slice(1);
			
			var texts:Array = text.split(/\r?\n/);
			var key:String; 
			for (var i:int=0;i < texts.length;i++)
			{
				var textLine:String = texts[i] as String;
				if (textLine && textLine.substr(0,2)!="//")
				{
					if (/^\w+=.*/.test(textLine))
					{
						var pos:int = textLine.indexOf("=");
						
						key = textLine.slice(0,pos);
						var value:String = textLine.slice(pos + 1);
						resource[textType][key] = value;
					}
					else if (key && textLine.length > 0)
					{
						resource[textType][key] += "\n" + textLine;//没有=则是上一行的继续
					}
				}
			}
		}
		
		/**
		 * 获得未经转换的多语言文本
		 * 
		 * @param res	文本标示，格式为@type.name。
		 * 不以@开头则返回原始文本，缺少.则在多个语言包里进行遍历查找
		 * @return 
		 * 
		 */		
		public function getOriginString(res:String):String
		{
			var bundle:Object;
			var result:String;
			if (res.charAt(0)=="@")
			{
				if (res.charAt(res.length - 1)=="\r")
					res = res.slice(0,res.length - 1);
				
				var dot:int = res.indexOf(".");
				if (dot == -1)
				{
					for each(bundle in resource)
					{
						result = bundle[res.slice(1)];
						if (result)
							return result;
					}
					return res;
				}
				else
				{
					bundle = resource[res.slice(1,dot)];
					if (bundle && bundle[res.slice(dot + 1)])
						return bundle[res.slice(dot + 1)];
					else
						return res;
				}
			}
			else
			{
				return res;
			}
			return null;
		}
		
		/**
		 * 获得经过转换的文本
		 * 
		 * @param res	文本标示，格式为@文件名.标签名
		 * @param parms	替换参数，将会按顺序替换文本里的{0},{1},{2}
		 * @param args 	附加参数，会传到customConversion的函数参数内
		 * @return 
		 * 
		 */		
		public function getString(res:String,parms:Array = null,args:Array = null):String
		{
			var result:String = getOriginString(res);
			
			if (result == null)
				return null;
			else
				return result.replace(/\{(.+?)\}/g,replaceFun);
			
			function replaceFun(matchedSubstring:String,capturedMatch:String,index:int,str:String):String 
			{ 
				var n:Number = parseFloat(capturedMatch);
				if (!isNaN(n))
				{
					if (parms && n < parms.length)
						return parms[n];
				}
				else
				{
					if (customConversion && customConversion.hasOwnProperty(capturedMatch))
					{
						var text:String;
						if (customConversion[capturedMatch] is Function)
							text = (customConversion[capturedMatch] as Function).apply(null,args);
						else
							text = customConversion[capturedMatch];
						
						if (text.charAt(0)=="#")
							text = ReflectUtil.eval(text.slice(1));
						
						return text;
					}
					else
					{
						return getString(capturedMatch,null,args);
					}
				}
				return capturedMatch
			}
		}
		
		/**
		 * 将容器里的所有文本框根据其内容里的文本标示替换成实际的文本
		 * @param obj
		 * 
		 */
		public function replaceAllTextField(obj:DisplayObject):void
		{
			var objs:Array = SearchUtil.findChildrenByClass(obj,TextField);
			for each (var item:TextField in objs)
			{
				var s:String = getString(item.text);
				if (s.indexOf("<html>") != -1)
					item.htmlText = s;
				else
					item.text = s;
			}
		}
	}
}