package ghostcat.util.text
{
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * HTML代码辅助类 
	 * @author flashyiyi
	 * 
	 */
	public class HTMLUtil
	{
		/**
		 * 加颜色
		 * @return 
		 * 
		 */
		public static function applyColor(v:String,c:Number):String
		{
			if (!isNaN(c))
				return "<font color='"+"#" + c.toString(16) + "'>" + v + "</font>"
			else
				return v;
		}
		
		/**
		 * 加字号
		 * @param v
		 * @param s
		 * @return 
		 * 
		 */
		public static function applySize(v:String,s:int):String
		{
			if (s)
				return "<font size='"+s.toString()+"'>" + v + "</font>"
			else
				return v;
		}
		
		/**
		 * 根据TextFormat附加HTML文本
		 * @param v
		 * @param format
		 * 
		 */
		public static function applyTextFormat(v:String,format:TextFormat):String
		{
			var t:TextField = new TextField();
			t.defaultTextFormat = format;
			t.text = v;
			return t.htmlText;
		}
	}
}