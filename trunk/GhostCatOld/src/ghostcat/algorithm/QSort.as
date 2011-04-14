package ghostcat.algorithm
{
	/**
	 * 快速排序
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class QSort
	{
		public static function sort(data:Array, left:int = 0, right:int = -1):Array
		{ 
			if (right == -1)
				right = data.length - 1;
			
			var i:int = left; 
			var j:int = right; 
			var middle:int = data[(left+right)/2];
			do
			{ 
				while (data[i] < middle && i < right) 
					i++;
				while (data[j] >= middle && j > left) 
					j--; 
				
				if(i <= j)
				{ 
					var t:* = data[i]; 
					data[i] = data[j]; 
					data[j] = t; 
					i++; 
					j--;
				}
			}
			while (i < j);
			
			if (left < j) 
				sort(data,left,j);
			
			if (right > i) 
				sort(data,i,right);
			
			return data; 
		}
	}
}