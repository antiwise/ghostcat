package ghostcat.util.data
{
	import flash.utils.ByteArray;

	/**
	 * ByteArray读取器
	 * 
	 * @author Administrator
	 * 
	 */
	public class ByteArrayReader
	{
		public var data:ByteArray;
		
		private var bitPos:int = 0;//在一个Byte型里从左到右的位的坐标
		/**
		 * 开始读取时的位置
		 */
		public var startPosition:int;
		
		public function ByteArrayReader(data:ByteArray)
		{
			this.data = data;
			startPosition = data.position;
		}
		
		/**
		 * 目前已读取的数据量
		 * @return 
		 * 
		 */
		public function get bytesReaded():int
		{
			return data.position - startPosition;
		}
		
		/**
		 * 按位读取数据
		 * 
		 * @param n
		 * @return 
		 * 
		 */
		public function readBits (n:uint):int
		{
			var temp:int = 0;
			var loop:int = Math.ceil((n + bitPos) / 8);
			var last:int = (n + bitPos) % 8;
			
			if (bitPos > 0)//获取上一次未获取的部分数据
				data.position -= 1;
			
			while (loop > 1)
			{
				temp  += BitUtil.getShiftedValue2(data.readUnsignedByte(), 8, bitPos, 8);
				
				loop--;
				
				if (loop > 1)
					temp = temp << (8 - bitPos);
				else
					temp = temp << last;
					
				bitPos  = 0;
			}
			temp += BitUtil.getShiftedValue2(data.readUnsignedByte(), 8, bitPos, last);
			bitPos = last;
			return temp;
		}
		
		/**
		 * 读取一个ByteArray
		 * 
		 * @param size	大小
		 * @return 
		 * 
		 */
		public function readByteArray(size:int):ByteArray
		{
			var newBytes:ByteArray = new ByteArray();
			data.readBytes(newBytes,0,size);
			return newBytes;
		}
		
		/**
		 * 读取一个对象。如果读取失败，则将position移回原值
		 * 
		 * @return 
		 * 
		 */
		public function readObject():Object
		{
			var oldPosition:int;
			oldPosition = data.position;
			try
			{
				var o:Object = data.readObject();
			}
			catch (e:Error)
			{
				data.position = oldPosition;
			};
			
			return o;
		}
	}
}