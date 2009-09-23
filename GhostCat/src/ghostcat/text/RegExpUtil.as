package ghostcat.text
{
	public final class RegExpUtil
	{
		/**
         * 匹配半角字符
         * 
         * @param str
         * @return 
         * 
         */        
        public static function matchAscii(str:String):Array
        {
        	return str.match(/[\x00-\xFF]*/g);
        }
        
        /**
         * 将文件路径字符串切分为数组。最后两个将会是文件名和扩展名。
         * 
         * @param url	路径
         * @return 
         * 
         */        
        public static function splitUrl(url:String):Array
        {
        	return url.split(/\/+|\\+|\.|\?/ig);
        }
        
        
        /**
         * 删除文本两端的空格
         * 
         * @param str	文本
         * @return 
         * 
         */        
        public static function trim(str:String):String
        {
        	return str.replace(/^\s*/,"").replace(/\s*$/,"");
        }
        
        /**
		 * 删除HTML标签
		 * 
		 */		
		public static function removeHTMLTag(text:String):String
		{
        	return text.replace(/<.*?>/g,"");
        }
        
        /**
         * 检测是否是邮箱地址
         * 
         * @param text
         * @return 
         * 
         */
        public static function isEmail(text:String):Boolean
        {
        	return (/^[\D]([\w-]+)?@[\w-]+\.[\w-]+(\.[\w-]{2,4})?$/).test(text);
        }
        
        /**
         * 检测是否是数字
         * 
         * @param text
         * @param digits	指定小数位
         * @return 
         * 
         */
        public static function isNumber(text:String,digits:int = -1):Boolean
        {
        	if (digits > 0)
        		return new RegExp("^-?(\\d|,)*\\.\\d{"+digits.toString()+"}$").test(text);
        	else
        		return (/^-?(\d|,)*[\.]?\d*$/).test(text);
        }
	}
}