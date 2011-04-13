package ghostcat.util.data
{
	import flash.utils.ByteArray;

	public final class ByteArrayUtil
	{
		/**
		 * 读取可变长度整型，使用每字节的首位判断是否下个字节还有数据
		 * @param bytes
		 * @return 
		 * 
		 */
		static public function read7BitEncodeInt(bytes:ByteArray):uint
		{
			var isEnd:Boolean = false;
			var result:uint = 0;
			while (!isEnd)
			{
				var v:uint = bytes.readUnsignedByte();
				isEnd = (v | (1 << 7)) != v;
				result = (result << 7) | (v & ((1 << 7) - 1));
			}
			return result;
		}
		
		/**
		 * 写入可变长度整型，使用每字节的首位判断是否下个字节还有数据
		 * @param bytes
		 * @param v
		 * @return 
		 * 
		 */
		static public function write7BitEncodeInt(bytes:ByteArray,v:uint):void
		{
			var result:Array = [];
			do
			{
				var n:uint = v & ((1 << 7) - 1);
				if (result.length)
					n = n | (1 << 7);
				result[result.length] = n;
				v = v >> 7;
			}
			while (v != 0);
			
			for (var i:int = result.length - 1;i >= 0;i--)
				bytes.writeByte(result[i]);
		}
	}
}