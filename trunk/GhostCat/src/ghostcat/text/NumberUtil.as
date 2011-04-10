package ghostcat.text
{
	/**
	 * 处理文本与数字有关的部分
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class NumberUtil
	{
		/**
		 * 创建时间
		 * @param v
		 * 
		 */
		public static function createDate(v:*):Date
		{
			if (isNaN(Number(v)))
				v = v.replace(/-/g,"/");
					
			return new Date(v);
		}
		/**
		 * 将日期转换为字符串
		 * 
		 * @param date	日期
		 * @param format	日期格式（yyyy-mm-dd,yyyy-m-d,yyyy年m月d日,Y年M月D日）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toDateString(date:Date,format:String="yyyy-mm-dd",utc:Boolean = false):String
		{
			var y:int = utc ? date.fullYearUTC : date.fullYear;
			var m:int = utc ? date.monthUTC : date.month;
			var d:int = utc ? date.dateUTC : date.date;
			
			switch (format){
				case "mm-dd":
					return fillZeros((m + 1).toString(),2) + "-" + fillZeros(d.toString(),2);
					break;
				case "yyyy-mm-dd":
					return y +"-" + fillZeros((m + 1).toString(),2) + "-" + fillZeros(d.toString(),2);
					break;
				case "yyyy-m-d":
					return y +"-" + (m + 1).toString() +"-" + d;
					break;
				case "yyyy年m月d日":
					return y +"年" + (m + 1).toString() +"月" + d + "日";
					break;
				case "Y年M月D日":
					return toChineseNumber(y) +"年" + toChineseNumber(m + 1) +"月" + toChineseNumber(d) + "日";
					break;
			}
			return date.toString();
		}
		
		/**
		 * 将时间转换为字符串
		 * 
		 * @param date	日期
		 * @param format	时间格式（hh:mm:ss，h:m:s，hh:mm:ss:ss.s，h:m:s:ss.s，h点m分s秒，H点M分S秒）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toTimeString(date:Date,format:String="hh:mm:ss",utc:Boolean = false):String
		{
			var h:int = utc ? date.hoursUTC : date.hours;
			var m:int = utc ? date.minutesUTC : date.minutes;
			var s:int = utc ? date.secondsUTC : date.seconds;
			var ms:Number = (utc ? date.millisecondsUTC : date.milliseconds) / 10;
			
			switch (format)
			{
				case "hh:mm":
					return fillZeros(h.toString(),2) + ":" + fillZeros(m.toString(),2);
					break;
				case "h:m":
					return h + ":" + m;
					break;
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
				case "h点m分s秒":
					return (h ? (h + "点"):"") + (m ? (m + "分"):"") + s + "秒";
					break;
				case "H点M分S秒":
					return (h ? (toChineseNumber(h) + "点"):"") + (m ? (toChineseNumber(m) + "分"):"") + toChineseNumber(s) + "秒";
					break;
			}
			return date.toString();
		}
		
		/**
		 * 将时间长度转换为字符串
		 * 
		 * @param date	日期
		 * @param format	时间格式（hh:mm:ss，h:m:s，hh:mm:ss:ss.s，h:m:s:ss.s，h小时m分钟s秒，H小时M分钟S秒）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toDurTimeString(time:Number,format:String="hh:mm:ss"):String
		{
			var ms:Number = (time % 1000) / 10;
			time /= 1000;
			var s:int = time % 60;
			time /= 60;
			var m:int = time % 60;
			time /= 60;
			var h:int = time;
			
			switch (format)
			{
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
					return (h ? (h + "小时"):"") + (m ? (m + "分钟"):"") + s + "秒";
					break;
				case "H小时M分钟S秒":
					return (h ? (toChineseNumber(h) + "小时"):"") + (m ? (toChineseNumber(m) + "分钟"):"") + toChineseNumber(s) + "秒";
					break;
			}
			return time.toString();
		}
		
		private static const chineseMapping:Array = ["","一","二","三","四","五","六","七","八","九"];
		private static const chineseLevelMapping:Array = ["","十","百","千"]
		private static const chineseLevel2Mapping:Array = ["","万","亿","兆"]
		
		/**
		 * 转换为汉字数字
		 * 
		 */		
		public static function toChineseNumber(n:Number):String
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
		
		/**
		 * 转换中文标点 
		 * @param v
		 * @param m1	是右单引号
		 * @param m2	是右双引号
		 * @return 
		 * 
		 */
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
		public static function addNumberSeparator(value:Number):String
		{
			var result:String = "";
			while (value >= 1000)
			{
				var v:int = value % 1000;
				result =  "," + fillZeros(v.toString(),3) + result;
				value = Math.floor(value / 1000);
			}
			value = Math.floor(value);
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
	}
}