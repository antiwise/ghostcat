package ghostcat.text
{
	import flash.utils.ByteArray;

	/**
	 * 关于文本处理的静态方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class TextUtil
	{
		/**
         * 从右侧截取固定长度字符串
         * 
         * @param str	字符串
         * @param len	长度
         * @return 
         * 
         */
        public static function right(str:String,len:int):String
        {
        	return str.slice(str.length - len);
        }
        
        /**
         * 忽略掉标签截取特定长度htmlText的文字
         * 
         * @param htmlText	HTML格式文本
         * @param startIndex	起始
         * @param len	长度
         * @return 
         * 
         */
        public static function subHtmlStr(htmlText:String,startIndex:Number = 0, len:Number = 0x7fffffff):String
        {
			if ((/<.*?>/).test(htmlText))
			{	
				var i:int=startIndex;
				var n:int=0;
				while (n < len && i < htmlText.length)
				{
					var result:Array= htmlText.substr(i).match(/^<([\/\w]+).*?>/);
					if (result!=null)
					{
						i += result[0].length;
					}
					else
					{
						i++;
						n++;
					}
				}
				return htmlText.substr(startIndex,i);
			}
			else
			{
				return htmlText.substr(startIndex,len);
			}
		}
		
		/**
		 * 删除HTML标签
		 *  
		 * @param htmlText
		 * @return 
		 * 
		 */
		public static function removeHTMLTag(htmlText:String):String
		{
			return htmlText.replace(/<.*?>/g,"");
		}
		
		/**
		 * 删除所有的\r 
		 * @param text
		 * 
		 */
		public static function removeR(text:String):String
		{
			return text.replace(/\r/g,"");
		}
		
		/**
		 * 插入换行符使得字体可以竖排
		 *  
		 * @param str
		 * @return 
		 * 
		 */
		public static function vertical(str:String):String
		{
			var result:String = "";
			for (var i:int = 0;i < str.length;i++)
			{
				result += str.charAt(i);
				if (i < str.length - 1)
					result += "\r";
			}
			return result;
		}
		
		/**
		 * 获得ANSI长度（中文按两个字符计算）
		 * @param data
		 * @return 
		 * 
		 */
		public static function getANSILength(data:String):int
		{
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte(data,"gb2312");
			return byte.length;
		}
        
	}
}