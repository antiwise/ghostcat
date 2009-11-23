package ghostcat.util.data
{
	/**
	 * 数据形式转换 
	 * @author flashyiyi
	 * 
	 */
	public final class ConversionUtil
	{
		/**
		 * 逗号分隔的ASC转换为数组 
		 * @param source
		 * @return 
		 * 
		 */
		public static function ASCToArray(source:String):Object
		{
			var data:Array = source.split("\n");
			for (var i:int = 0;i<data.length;i++)
			{
				var text:String = data[i];
				text = text.replace("\r","");
				data[i] = text.split(",");
			}
			return data;
		}
		
		/**
		 * 对象数组转换为带标题二维数组 
		 * @param source
		 * @return 
		 * 
		 */
		public static function objectToArray(source:Array):Array
		{
			if (source.length == 0)
				return [];
			
			var result:Array = [];
			var key:*;
			var arr:Array;
			arr = [];
			for (key in source[0])
				arr.push(key);
			result.push(arr);
			
			for (var i:int = 0; i < source.length; i++)
			{
				arr = [];
				var data:Object = source[i];
				for (key in data)
					arr.push(data[key]);
				result.push(arr);	
			}
			return result;
		}
		
		/**
		 * 带标题二维数组转换为对象数组 
		 * @param source
		 * @return 
		 * 
		 */
		public static function arrayToObject(source:Array):Array
		{
			if (source.length <= 1)
				return [];
			
			var result:Array = [];
			for (var i:int = 1; i < source.length; i++)
			{
				var data:Object = new Object();
				for (var j:int = 0;j < source[i].length;j++)
					data[source[0][j]] = source[i][j];
				result.push(data);	
			}
			return result;
		}
	}
}