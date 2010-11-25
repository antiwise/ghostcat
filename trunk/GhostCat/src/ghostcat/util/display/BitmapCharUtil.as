package ghostcat.util.display
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 位图数字 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapCharUtil
	{
		/**
		 * 用位图拼接出一段文本
		 * 
		 * @param text	文字
		 * @param skin	作为字符图像的位图，会根据字符数量平均切割
		 * @param charRange	skin包含的字符集（0-9,a,U+80FF）
		 * @return 
		 * 
		 */
		public static function create(text:String,skin:BitmapData,charRange:String = "0-9"):BitmapData
		{
			var chars:String = execCharRange(charRange);
			var charWidth:int = skin.width / chars.length;
			var textLength:int = text.length;
			var result:BitmapData = new BitmapData(charWidth * textLength,skin.height,true,0);
			for (var i:int = 0; i < textLength; i++)
			{
				var index:int = chars.indexOf(text.charAt(i));
				if (index != -1)
					result.copyPixels(skin,new Rectangle(charWidth * index,0,charWidth,skin.height),new Point(charWidth * i,0));
			}
			return result;
		}
		
		/**
		 * 将一个位图插入到另一个位图的插入区域内，并将其他内容推挤开
		 * 
		 * @param charBitmapData	需要插入的位图
		 * @param source	被插入的位图
		 * @param insertRectColor	插入区域颜色
		 * @return 
		 * 
		 */
		public static function insert(charBitmapData:BitmapData,source:BitmapData,insertRectColor:uint = 0xFF0000):BitmapData
		{
			var rect:Rectangle = source.getColorBoundsRect(0xFFFFFF,insertRectColor);
			var result:BitmapData = new BitmapData(charBitmapData.width + source.width - rect.width,source.height,true,0);
			result.copyPixels(source,new Rectangle(0,0,rect.x,source.height),new Point());
			result.copyPixels(charBitmapData,charBitmapData.rect,rect.topLeft);
			result.copyPixels(source,new Rectangle(rect.right,0,source.width - rect.right,source.height),new Point(rect.x + charBitmapData.width - rect.width,0));
			return result;
		}
		
		/**
		 * 先通过位图拼接出一段文本，然后插入另一个位图的插入区域内，是create和insert的综合
		 *  
		 * @param source	被插入的位图
		 * @param text	文字
		 * @param skin	作为字符图像的位图，会根据字符数量平均切割
		 * @param charRange	skin包含的字符集（0-9,a,U+80FF）
		 * @param insertRectColor	插入区域颜色
		 * @return 
		 * 
		 */
		public static function createAndInsert(source:BitmapData,text:String,skin:BitmapData,charRange:String = "0-9",insertRectColor:uint = 0xFF0000):BitmapData
		{
			var charBitmapData:BitmapData = create(text,skin,charRange);
			var result:BitmapData = insert(charBitmapData,source,insertRectColor);
			charBitmapData.dispose();
			return result;
		}
		
		/**
		 * 获得字符范围 
		 * @param v
		 * @return 
		 * 
		 */
		private static function execCharRange(v:String):String
		{
			var list:Array = v.split(",");
			var result:String = "";
			for each (var child:String in list)
			{
				if (child.length == 3 && child.charAt(1) == "-")
				{
					var fromCharCode:int = child.charCodeAt(0);
					var toCharCode:int = child.charCodeAt(2);
					var len:int = toCharCode - fromCharCode + 1;
					for (var i:int = 0;i < len;i++)
					{
						result += String.fromCharCode(fromCharCode + i);
					}
				}
				else if (child.length > 2 && child.charAt(0) == "U" && child.charAt(1) == "+")
				{
					result += String.fromCharCode(parseInt(child.slice(2),16));
				}
				else
				{
					result += child;
				}
			}
			return result;
		}
	}
}