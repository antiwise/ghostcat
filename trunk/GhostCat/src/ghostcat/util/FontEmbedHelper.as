package ghostcat.util
{
	import ghostcat.text.TextUtil;

	/**
	 * 帮组嵌入字体的类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class FontEmbedHelper
	{
		/**
		 * 将需要陷入的文字作为参数输入，将会trace出一段代码。
		 * 添加这段代码即可成功嵌入文字。
		 * 
		 * 最近发现有人做了一个工具，和这个的原理一样，包含导入文本文件并滤字的功能，非常好用。我这个可以无视了。
		 * http://kevincao.com/2009/06/font-converter-update/
		 * 
		 * @param fontName	FLASH内部的字体名称，内部将以这个名字为准
		 * @param systemName	系统字体名称
		 * @param italic	是否是粗体
		 * @param weight	是否是斜体
		 * @param text	需要嵌入的文字
		 * 
		 */
		public static function traceEmbedFontCode(fontName:String, systemFont:String, italic:Boolean = false, weight:Boolean = false,text:String=null):void
		{
			var result:String = "";
			result += '[Embed(systemFont="'+ systemFont +'", fontName="'+ fontName +'",mimeType="application/x-font"';
			if (italic) 
				result+= ', fontStyle="italic"';
			if (weight) 
				result+= ', fontWeight="bold"';
				
			if (text)
			{
				var textArr:Array = [];
				for (var i:int = 0;i < text.length;i++)
					textArr.push(text.charCodeAt(i));
				textArr.sort(Array.NUMERIC);
				
				var unicodeRange:String = "";
				var prev:uint;
				for (i = 0;i < textArr.length;i++)
				{
					var now:uint = textArr[i];
					if (now != prev)
					{
						if (unicodeRange != "")
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
	}
}