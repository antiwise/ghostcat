package ghostcat.util
{
	
	/**
	 * 一个用来处理布尔数组的类。
	 * 
	 * 布尔值将会被紧密储存，一个uint就可以保存32个状态。保存的时候直接保存uint既可。
	 * 这种东西用来保存人物异常状态是再好不过的了，可以拥有非常好的扩展性。
	 * 
	 * 此外也可以用来保存任务状态，成就完成列表，流程进度。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitArray
	{
		public static const BIT_LEN:int = 32;
		
		private var data:Array = [];
		
		public function BitArray(source:Array = null)
		{
			if (source)
				createFromArray(source);
		}
		
		/**
		 * 从数组创建，内容可以是布尔型，也可以是数值型。
		 * 
		 * @param source
		 * 
		 */
		public function createFromArray(source:Array):void
		{
			var n:int = 0;
			for (var i:int = 0;i<source.length;i++)
			{
				if (source[i] is Boolean)
				{
					setValue(n,source[i]);
					n++;
				}
				else
				{
					for (var j:int = 0; j < BIT_LEN;j++)
					{
						setValue(n,BitUtil.getBit(source[i],j));
						n++;
					}
				}
			}
		}
		
		/**
		 * 从数值数组里创建，这个方法比createFromArray要快。
		 * 
		 * @param source
		 * 
		 */
		public function createFromIntArray(source:Array):void
		{
			data = source.slice();
		}
		
		/**
		 * 数组长度。这个值只可能是32的倍数。
		 * @return 
		 * 
		 */
		public function get length():int
		{
			return data.length * BIT_LEN;
		}
		
		/**
		 * 取数
		 * 
		 * @param v
		 * @return 
		 * 
		 */
		public function getValue(v:int):Boolean
		{
			var dataIndex:int = int(v/BIT_LEN);
			if (dataIndex > data.length - 1)
				return false;
			
			var n:uint = data[dataIndex];
			return BitUtil.getBit(n, v % BIT_LEN);
		}
		
		/**
		 * 设置
		 * 
		 * @param v
		 * @param value
		 * 
		 */
		public function setValue(v:int, value:Boolean):void
		{
			var dataIndex:int = int(v/BIT_LEN);
			var n:uint = data[dataIndex];
			data[dataIndex] = BitUtil.setBit(n, v % BIT_LEN, value);
		}
		
		/**
		 * 输出成一个数值类型的数组
		 * 
		 * @return 
		 * 
		 */
		public function toIntArray():Array
		{
			return data.slice();
		}
		
		/**
		 * 输出成一个Boolean类型的数组
		 * 
		 * @return 
		 * 
		 */
		public function toArray():Array
		{
			var result:Array = [];
			for (var i:int = 0;i<length;i++)
				result.push(getValue(i));
			
			return result;
		}
	}
}