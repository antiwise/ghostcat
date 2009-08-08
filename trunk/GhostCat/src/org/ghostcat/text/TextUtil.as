package org.ghostcat.text
{
	

	/**
	 * 关于文本处理的静态方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class TextUtil
	{
		/**
		 * 将日期转换为字符串
		 * 
		 * @param date	日期
		 * @param format	日期格式（yyyy-mm-dd,yyyy-m-d,yyyy年m月d日,Y年M月D日）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toDateString(date:Date,format:String=""):String
		{
			var y:int = date.fullYear;
			var m:int = date.month;
			var d:int = date.date;
			
			switch (format){
				case "yyyy-mm-dd":
					return y +"-" + fillZeros(m.toString(),2) + "-" + fillZeros(d.toString(),2);
					break;
				case "yyyy-m-d":
					return y +"-" + m +"-" + d;
					break;
				case "yyyy年m月d日":
					return y +"年" + m +"月" + d + "日";
					break;
				case "Y年M月D日":
					return toChineseNumber(y) +"年" + toChineseNumber(m) +"月" + toChineseNumber(d) + "日";
					break;
			}
			return date.toString();
		}
		
		/**
		 * 将时间转换为字符串
		 * 
		 * @param date	日期
		 * @param format	时间格式（hh:mm:ss，h:m:s，hh:mm:ss:ss.s，h:m:s:ss.s，h小时m分钟s秒，H小时M分钟S秒）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toTimeString(date:Date,format:String=""):String
		{
			var h:int = date.hours;
			var m:int = date.minutes;
			var s:int = date.seconds;
			var ms:Number = date.milliseconds/10;
			
			switch (format){
				case "hh:mm:ss":
					return fillZeros(h.toString(),2) + ":" + fillZeros(m.toString(),2) + ":" + fillZeros(s.toString(),2);
					break;
				case "h:m:s":
					return h + ":" + m + ":" + s;
					break;
				case "hh:mm:ss:ss.s":
					return fillZeros(h.toString(),2) + ":" + fillZeros(m.toString(),2) + ":" + fillZeros(s.toString(),2) + ":" + ms.toFixed(1);
					break;
				case "h:m:s:ss.s":
					return h + ":" + m + ":" + s + ":" + ms.toFixed(1);
					break;
				case "h小时m分钟s秒":
					return h + "小时" + m + "分钟" + s + "秒";
					break;
				case "H小时M分钟S秒":
					return toChineseNumber(h) + "小时" + toChineseNumber(m) + "分钟" + toChineseNumber(s) + "秒";
					break;
			}
			return date.toString();
		}
		
		private static const chineseMapping:Array = ["","一","二","三","四","五","六","七","八","九"];
		private static const chineseLevelMapping:Array = ["","十","百","千"]
		private static const chineseLevel2Mapping:Array = ["","万","亿","兆"]
		
		/**
		 * 转换为汉字数字
		 * 
		 */		
		public static function toChineseNumber(n:int):String
		{
			var result:String = "";
			var level:int = 0;
			while (n > 0)
			{
				var v:int = n % 10;
				if (level % 4 ==0)
					result = chineseLevel2Mapping[level / 4] + result;
				
				if (v > 0)
				{
					if (level % 4 == 1 && v == 1){
						result = chineseLevelMapping[level % 4] + result;
					}else{
						result = chineseMapping[v] + chineseLevelMapping[level % 4] + result;
					}
				}
				else
				{
					result = chineseMapping[v] + result;
				}
				n = n / 10;
				level++;
			}
			
			return result;
		}
		
		private static const punctuationMapping:Array = [[",",".",":",";","?","\\","\/","[","]","`"],
															["，","。","：","；","？","、","、","【","】","·"]]
		
		public static function toChinesePunctuation(v:String,m1:Boolean = false,m2:Boolean = false):String
		{
			var result:String = "";
			for (var i:int = 0;i<v.length;i++)
			{
				var ch:String = v.charAt(i);
				if (ch == "'")
				{
					m1 = !m1;
					result += m1?"‘":"’";
				}
				else if (ch == "\"")
				{
					m2 = !m2;
					result += m2?"“":"”";
				}
				else
				{
					var index:int = (punctuationMapping[0] as Array).indexOf(v.charAt(i));
					if (index != -1)
						result += punctuationMapping[1][index];
					else
						result += v.charAt(i);
				}
			}
			return result;
		}
		
		/**
		 * 在数字中添加千位分隔符
		 * 
		 */		 	
		public static function addNumberSeparator(value:int):String
		{
			var result:String = "";
            while (value >= 1000)
            {
            	var v:int = value % 1000;
                result =  "," + fillZeros(v.toString(),3) + result;
                value = value / 1000;
            }
            return result = String(value) + result;
		}
		
		/**
		 * 将数字用0补足长度
		 * 
		 */		
		public static function fillZeros(str:String, len:int, flag:String="0"):String
        {
            while (str.length < len) 
            {
                str = flag + str;
            }
            return str;
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
         * 忽略掉标签截取特定长度htmlText的文字
         * 
         * @param htmlText	HTML格式文本
         * @param startIndex	起始
         * @param len	长度
         * @return 
         * 
         */
        public static function subHtmlStr(htmlText:String,startIndex:Number = 0, len:Number = 0x7fffffff):String{
			var i:int=startIndex;
			var n:int=0;
			while (n < len && i< htmlText.length)
			{
				var presult:Array= htmlText.substr(i).match(/^<([\/\w]+).*?>/);
				if (presult!=null)
					i += presult[0].length;
				else
				{
					i++;
					n++;
				}
			}
			return htmlText.substr(startIndex,i);
		}
        
	}
}