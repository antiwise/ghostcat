package ghostcat.util.encrypt
{
	import flash.utils.ByteArray;

	/**
	 * 一个普通的错位加密
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SimpleEncrypt implements IEncrypt
	{
		protected function encodeCommand(v:Number):Number
		{
			var v1:Number = (v & 0x000000FF);
			var v2:Number = (v & 0x0000FF00) >> 8;
			var v3:Number = (v & 0x00FF0000) >> 16;
			var v4:Number = (v & 0xFF000000) >> 24;
			
			return (v1 << 16)|(v2 << 24)|v3|(v4 << 8);
		}
		protected function decodeCommand(v:Number):Number
		{
			var v3:Number = (v & 0x000000FF);
			var v4:Number = (v & 0x0000FF00) >> 8;
			var v1:Number = (v & 0x00FF0000) >> 16;
			var v2:Number = (v & 0xFF000000) >> 24;
			
			return v1|(v2 << 8)|(v3 << 16)|(v4 << 24);
		}
		/** @inheritDoc*/
		public function encode(data:*):*
		{
			if (data is Number)
			{
				return encodeCommand(data);	
			}
			else
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeObject(data);
				bytes.position = 0;
				var rBytes:ByteArray = new ByteArray();
				while (bytes.bytesAvailable)
				{
					rBytes.writeInt(encodeCommand(bytes.readByte()))
				}
				return rBytes;
			}
		}
		/** @inheritDoc*/
		public function decode(data:*):*
		{
			if (data is Number)
			{
				return decodeCommand(data);
			}
			else if (data is ByteArray)
			{
				var bytes:ByteArray = data as ByteArray;
				bytes.position = 0;
				var rBytes:ByteArray = new ByteArray();
				while (bytes.bytesAvailable)
				{
					rBytes.writeByte(decodeCommand(bytes.readInt()))
				}
				rBytes.position = 0;
				return rBytes.readObject();
			}
			else
			{
				throw new Error("数据类型不正确")
			}
		}
	}
}