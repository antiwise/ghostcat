package org.ghostcat.util
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
		
		public var bitPos:int = 0;//在一个Byte型里从左到右的位的坐标
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
		 * 读取一个有符号数 
		 * @param size	占用的字节数
		 * 
		 */
		public function readInt(size:int):int
		{
			switch (size)
			{
				case 1:
					return data.readByte();
					break;
				case 2:
					return data.readShort();
					break;
				case 4:
					return data.readInt();
					break;
				default:
					throw new Error("错误的取值")
			}
		}
		
		/**
		 * 读取一个无符号数 
		 * @param size	占用的字节数
		 * 
		 */
		public function readUint(size:int):uint
		{
			switch (size)
			{
				case 1:
					return data.readUnsignedByte();
					break;
				case 2:
					return data.readUnsignedShort();
					break;
				case 4:
					return data.readUnsignedInt();
					break;
				default:
					throw new Error("错误的取值")
			}
		}
		
		/**
		 * 读取一个以0结尾的字符串
		 * 
		 * @param length	长度，默认则以取到0为止或者文件尾
		 * @return 
		 * 
		 */
		public function readString(length:int = 0):String
		{
			var text:String = "";
			
			try
			{
				if (length > 0)
					text = data.readUTFBytes(length);
				else
				{
					var v:int = data.readUnsignedByte();
					while (v)
					{
						text += String.fromCharCode(v);
						v = data.readUnsignedByte();
					}
				}
			}
			catch (e:Error)
			{};
			
			return text;
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