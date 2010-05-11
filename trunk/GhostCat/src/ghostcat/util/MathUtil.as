package ghostcat.util
{
	/**
	 * 数学相关方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MathUtil
	{
		/**
		 * 将数值限制在一个区间内
		 * 
		 * @param v	数值
		 * @param min	最大值
		 * @param max	最小值
		 * 
		 */		
		public static function limitIn(v:Number,min:Number,max:Number):Number
		{
			return Math.min(Math.max(v,min),max);
		}
		
		/**
		 * 返回的是数学意义上的atan（坐标系与Math.atan2上下颠倒）
		 * 
		 * @param dx
		 * @param dy
		 * @return 
		 * 
		 */
		public static function atan2(dx:Number, dy:Number):Number
		{
			var a:Number;
			if (dx == 0) 
				a = Math.PI/2;
			else if (dx > 0) 
				a = Math.atan(Math.abs(dy/dx));
			else
				a = Math.PI - Math.atan(Math.abs(dy/dx));
			
			if (dy >= 0) 
				return a;
			else 
				return -a;
			
		}
		
		/**
		 * 求和
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function sum(arr:Array):Number
		{
			var result:Number = 0.0;
			for each (var num:Number in arr)
				result += num;
			return result;
		}
		
		/**
		 * 平均值
		 *  
		 * @param arr
		 * @return 
		 * 
		 */
		public static function avg(arr:Array):Number
		{
			return sum(arr)/arr.length;
		}
		
		/**
		 * 最大值
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function max(arr:Array):Number
		{
			var result:Number = NaN;
			for (var i:int = 0;i < arr.length;i++)
			{
				if (isNaN(result) || arr[i] > result)
					result = arr[i];
			}
			return result;
		}
		
		/**
		 * 最小值
		 * 
		 * @param arr
		 * @return 
		 * 
		 */
		public static function min(arr:Array):Number
		{
			var result:Number = NaN;
			for (var i:int = 0;i < arr.length;i++)
			{
				if (isNaN(result) || arr[i] < result)
					result = arr[i];
			}
			return result;
		}
	}
}