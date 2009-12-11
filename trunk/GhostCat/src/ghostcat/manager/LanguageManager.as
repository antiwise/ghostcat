package ghostcat.manager
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	import ghostcat.operation.LoadOper;
	import ghostcat.operation.Queue;
	import ghostcat.text.RegExpUtil;
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
	public class LanguageManager extends Singleton
	{
		static public function get instance():LanguageManager
		{
			return Singleton.getInstanceOrCreate(LanguageManager) as LanguageManager;
		}
		
		/**
		 * getString是最常用的方法，移到静态方法里方便调用
		 */		
		static public function getString(res:String,parms:Array=null):String
		{
			return instance.getString(res,parms)
		}
		
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
			GText.textChangeHandler = v ? replaceTextField : null;
		}
		
		public function get registerGText():Boolean
		{
			return GText.textChangeHandler == replaceTextField;
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
			var loader:LoadOper = new LoadOper(url,embedClass,completeHandler);
			loader.commit(queue);
			return loader;
		}
		
		private function completeHandler(event:Event):void
		{
			var oper:LoadOper = event.currentTarget as LoadOper;
			var urlSpit:Array = RegExpUtil.splitUrl(oper.request.url);
			var textType:String = urlSpit[urlSpit.length - 2];
			resource[textType]=new Object();
					
			var texts:Array = oper.data.toString().split(/\r?\n/);
			for (var i:int=0;i < texts.length;i++)
			{
				var textLine:String = texts[i] as String;
				if (textLine.substr(0,2)!="//")
				{
					var textArr:Array = textLine.split(/\s*=\s*/);
					if (textArr.length == 2)
						resource[textType][textArr[0]] = textArr[1];
				}
			}
		}
		
		private function replaceTextField(control:GText):void
		{
			var text:String = control.text;
			if (text.charAt(0)=="@")
				control.text = getString(text);
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
				var dot:int = res.indexOf(".");
				if (dot == -1)
				{
					for each(bundle in resource)
					{
						result = bundle[res.slice(1)];
						if (result)
							return result;
					}
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
		 * @return 
		 * 
		 */		
		public function getString(res:String,parms:Array=null):String
		{
			var result:String = getOriginString(res);
			
			if (result==null)
				return null;
			
			if (parms)
			{
				for (var i:int = 0;i<parms.length;i++)
				{
					result = result.replace(new RegExp("\\{"+i+"\\}","g"),parms[i]);
				}
			}
			for (var conv:* in customConversion)
			{
				var text:String
				if (customConversion[conv] is Function)
					text = customConversion[conv]();
				else
					text = customConversion[conv];
				
				if (text.charAt(0)=="#")
					text = ReflectUtil.eval(text.slice(1));
				result = result.replace(new RegExp("\\{"+conv+"\\}","g"),text);
			}
			return result;
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
				item.text = getString(item.text);
		}
	}
}