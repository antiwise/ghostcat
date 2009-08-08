package org.ghostcat.manager
{
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import org.ghostcat.core.Singleton;
	import org.ghostcat.text.TextUtil;
	import org.ghostcat.util.Util;

	/**
	 * 这个类用于保存字体样式以及帮助嵌入字体。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FontManager extends Singleton
	{
		static public function get instance():CacheManager
		{
			return Singleton.getInstanceOrCreate(CacheManager) as CacheManager;
		}
		
		/**
		 * 将需要陷入的文字作为参数输入，将会trace出一段代码。
		 * 添加这段代码即可成功嵌入文字。
		 * 
		 * @param fontName	FLASH内部的字体名称，内部将以这个名字为准
		 * @param systemName	系统字体名称
		 * @param style	是否是粗体或者斜体。不同样式的字体需要分别嵌入
		 * @param text	需要嵌入的文字
		 * 
		 */
		public static function traceEmbedFontCode(fontName:String, systemFont:String, style:String = null,text:String=null):void
		{
			var result:String = "";
			result += '[Embed(systemFont="'+ systemFont +'", fontName="'+ fontName +'",mimeType="application/x-font"';
			if (style) result+= ', fontStyle="'+ style + '"';
			if (text)
			{
				var textArr:Array = [];
				for (var i:int = 0;i < text.length;i++)
					textArr.push(text.charCodeAt(i));
				textArr.sort(Array.NUMERIC);
				
				var unicodeRange:String="";
				var prev:uint;
				for (i = 0;i < textArr.length;i++)
				{
					var now:uint = textArr[i];
					if (now != prev)
					{
						if (unicodeRange!="")
							unicodeRange += ",";
						unicodeRange += "U+" + TextUtil.fillZeros(now.toString(16).toUpperCase(),4);
					}
					prev = now;
				}
				result += ', unicodeRange="'+ unicodeRange +'"';
			}
			result += ')]';
			trace(result);
			trace('var '+ fontName +':Class;');
			trace('Font.registerFont('+ fontName +');');
		}
		
		private var textFormats:Dictionary = new Dictionary();
		
		/**
		 * 注册一个字体样式
		 * 
		 * @param name	样式名称
		 * @param fontObj	字体属性对象
		 * 
		 */
		public function registerTextFormat(name:String,fontObj:*):void
		{
			var textFormat:TextFormat;
			if (fontObj is TextFormat)
				textFormat = fontObj as TextFormat;
			else
				textFormat = Util.createObject(TextFormat,fontObj);
				
			textFormats[name] = textFormat;
		}
		
		/**
		 * 获取已注册的字体样式
		 * 
		 * @param name	样式名称
		 * @return 
		 * 
		 */
		public function getTextFormat(name:String):TextFormat
		{
			return textFormats[name];
		}
	}
}