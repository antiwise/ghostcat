package ghostcat.util
{
	/**
	 * 日期类
	 * @author flashyiyi
	 * 
	 */
	public final class DateUtil
	{
		/**
		 * 获得当前月的天数 
		 * @param d
		 * 
		 */
		static public function getDayInMonth(d:Date):int
		{
			const days:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
			var day:int = days[d.month];
			if (isLeapYear(d.fullYear))
				day++;
			
			return day;
		}
		
		/**
		 * 是否是闰年
		 * @param year
		 * @return 
		 * 
		 */
		static public function isLeapYear(year:int):Boolean
		{
			if (year % 4 ==0)
				if (year % 400 == 0)
					if (year % 3200 == 0)
						if (year % 86400 == 0)
							return false;
						else
							return true;
					else 
						return false;
				else 
					return true;
			else
				return false;
		}
		
		/**
		 * 根据字符串创建日期 
		 * (yy-mm-dd)
		 * @param v
		 * 
		 */
		static public function createDateFromString(v:String,timezone:Number = NaN):Date
		{
			v = v.replace(/-/g,"/");
			if (!isNaN(timezone))
			{
				var str:String = Math.abs(timezone).toString();
				if (str.length == 1)
					str = "0" + str;
				
				v = v + " GMT" + (timezone >= 0 ? "+" : "-") + str + "00";
			}
			return new Date(v);
		}
	}
}