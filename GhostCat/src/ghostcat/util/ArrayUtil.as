package ghostcat.util
{
	import flash.utils.Dictionary;

	/**
	 * 数组类
	 * @author flashyiyi
	 * 
	 */
	public final class ArrayUtil
	{
		/**
		 * 创建一个数组
		 * @param length	长度
		 * @param fill	填充
		 * 
		 */
		public static function create(len:Array,fill:* = null):Array
		{
			len = len.concat();
			
			var arr:Array = [];
			var l:int = len.shift();
			for (var i:int = 0; i < l; i++)
			{
				if (len.length)
					arr[i] = create(len,fill);
				else
					arr[i] = fill;
			}	
			return arr;
		}
		
		/**
		 * 将一个数组附加在另一个数组之后
		 * 
		 * @param arr	目标数组
		 * @param value	附加的数组
		 * 
		 */
		public function append(arr:Array,value:Array):void
		{
			arr.push.apply(null,value);
		}
		
		/**
		 * 获得两个数组的共用元素
		 * 
		 * @param array1	数组对象1
		 * @param array2	数组对象2
		 * @param result	共有元素
		 * @param array1only	数组1独有元素
		 * @param array2only	数组2独有元素
		 * @return 	共有元素
		 * 
		 */
		public static function hasShare(array1:Array,array2:Array,result:Array = null,array1only:Array = null,array2only:Array = null):Array
		{
			if (result == null)
				result = [];
			
			var array2dict:Dictionary = new Dictionary();
			var obj:*;
			for each (obj in array2)
				array2dict[obj] = null;
			
			if (array2only != null)
				var resultDict:Dictionary = new Dictionary();
			
			for each (obj in array1)
            {
                if (array2dict.hasOwnProperty(obj))
				{
					result[result.length] = obj;
					if (resultDict)
						resultDict[obj] = null;
				}
				else if (array1only != null)
				{
					array1only[array1only.length] = obj;
				}
			}
			
			if (array2only != null)
			{
				for each (obj in array2)
				{
					if (!resultDict.hasOwnProperty(obj))
						array2only[array2only.length] = obj;
				}
			}
			
            return result;
		}
		
		/**
		 * 获得数组中特定标示的对象
		 * 
		 * getMapping([{x:0,y:0},{x:-2,y:4},{x:4,y:2}],"x",-2) //{x:-2:y:4}(x = -2)
		 * getMapping([[1,2],[3,4],[5,6]],0,3) //[3,4](第一个元素为3)
		 *  
		 * @param arr	数组
		 * @param value	值
		 * @param field	键
		 * @return 
		 * 
		 */
		public static function getMapping(arr:Array, field:*,value:*):Object
        {
            for (var i:int = 0;i<arr.length;i++)
            {
            	var o:* = arr[i];
            	
                if (o[field] == value)
                	return o;
            }
            return null;
        }
        
        /**
		 * 获得数组中某个键的所有值
		 * 
		 * getFieldValues([{x:0,y:0},{x:-2,y:4},{x:4,y:2}],"x")	//[0,-2,4]
		 *  
		 * @param arr	数组
		 * @param field	键
		 * @return 
		 * 
		 */
		public static function getFieldValues(arr:Array, field:*):Array
        {
        	var result:Array = [];
            for (var i:int = 0;i<arr.length;i++)
            {
            	var o:* = arr[i];
            	
                result[i] = o[field];
            }
            return result;
        }
	}
}