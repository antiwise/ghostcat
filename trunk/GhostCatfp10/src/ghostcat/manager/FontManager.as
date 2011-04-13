package ghostcat.manager
{
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import ghostcat.util.text.TextUtil;
	import ghostcat.util.Util;
	import ghostcat.util.core.Singleton;

	/**
	 * 这个类用于保存字体样式以及帮助嵌入字体。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class FontManager extends EventDispatcher
	{
		static private var _instance:FontManager;
		static public function get instance():FontManager
		{
			if (!_instance)
				_instance = new FontManager();
			
			return _instance;
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
		
		/**
		 * 按名称获得字体
		 * 
		 * @param name	字体名
		 * @param fontStyle	字体类型
		 * @param deviceFont	是否包括设备字体
		 * @return 
		 * 
		 */
		public function getFontByName(name:String,fontStyle:String = "regular", deviceFont:Boolean = false):Font
		{
			var arr:Array = Font.enumerateFonts(deviceFont);
			for (var i:int = 0;i < arr.length;i++)
			{
				var f:Font = arr[i] as Font;
				if (f.fontName == name && f.fontStyle == fontStyle)
					return f;
			}
			return null;
		}
		
		/**
		 * 从TextFormat中获得字体类型
		 * 
		 * @param textFormat
		 * @return 
		 * 
		 */
		public function getFontStyle(textFormat:TextFormat):String
		{
			var bold:Boolean = textFormat.bold;
			var italic:Boolean = textFormat.italic;
			if (bold && italic)
				return FontStyle.BOLD_ITALIC;
			else if (bold)
				return FontStyle.BOLD;
			else if (italic)
				return FontStyle.ITALIC;
			else
				return FontStyle.REGULAR;
				
			return null;
		}
		
		/**
		 * 判断文本的字体是否已经嵌入
		 *  
		 * @param text
		 * 
		 */
		public function isEmbed(text:String,textFormat:TextFormat):Boolean
		{
			var font:Font = getFontByName(textFormat.font,getFontStyle(textFormat),false);
			return font && font.hasGlyphs(text)
		}
		
		/**
		 * 根据字体嵌入情况自动设置文本框的embedFonts属性，仅适用于使用defaultTextFormat的情况
		 * @param text
		 * 
		 */
		public function autoEmbedFonts(textField:TextField):void
		{
			textField.embedFonts = isEmbed(textField.text,textField.defaultTextFormat);
		}
	}
}