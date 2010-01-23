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
		public static function objectArrayToTitleArray(source:Array):Array
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
		public static function titleArrayToObjectArray(source:Array):Array
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
		
		/**
		 * 对象数组转换为单一对象 
		 * @param source
		 * @return 
		 * 
		 */
		public static function arrayToObject(source:Array,key:String,value:String):Object
		{
			if (source.length == 0)
				return [];
			
			var result:Object = {};
			for (var i:int = 0; i < source.length; i++)
			{
				result[source[i][key]] = source[i][value];	
			}
			return result;
		}
		
		/**
		 * 过滤对象数组列 
		 * @param source
		 * @return 
		 * 
		 */
		public static function filterObjectArray(source:Array,filter:Array):Array
		{
			var i:int;
			for (i = 0; i < source.length;i++)
			{
				var newObj:Object = {};
				for (var j:int = 0;j < filter.length;j++)
				{
					var key:* = filter[j];
					newObj[key] = source[i][key];
				}
				source[i] = newObj;
			}
			
			return source;
		}
		
		/**
		 * 过滤数组列  
		 * @param source
		 * @param filter
		 * @return 
		 * 
		 */
		public static function filterTitleArray(source:Array,filter:Array):Array
		{
			var i:int;
			var newHeader:Array = [];
			var arr:Array = [];
			for (i = 0; i < filter.length;i++)
			{
				var index:int = source[0].indexOf(filter[i]);
				if (index != -1)
				{
					arr.push(index);
					newHeader.push(filter[i]);
				}
			}
			filter = arr;
			
			source = source.slice(1);
			for (i = 0; i < source.length;i++)
			{
				var newObj:Array = [];
				for (var j:int = 0;j < filter.length;j++)
				{
					var key:* = filter[j];
					newObj[key] = source[i][key];
				}
				source[i] = newObj;
			}
			source.unshift(newHeader);
			
			return source;
		}
	}
}