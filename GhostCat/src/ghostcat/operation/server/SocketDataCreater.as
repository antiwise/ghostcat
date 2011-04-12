package ghostcat.operation.server
{
	import flash.utils.ByteArray;

	/**
	 * 	BOOL 布尔型
	 * 	U8 8位无符号整型
	 * 	U16 16位无符号整型
	 * 	U32 32位无符号整型
	 * 	I8 8位无符号整型
	 * 	I16 16位无符号整型
	 * 	I32 32位无符号整型
	 * 	F32 32位浮点数
	 * 	F64 64位双精度浮点数
	 * 	UTF 字符串	长度为U16
	 * 	MB 二进制数据	长度为U32
	 * 	[]	数组	长度为U32
	 */
	
	public final class SocketDataCreater
	{
		static public function encode(o:Object,dataFormat:*):ByteArray
		{
			if (dataFormat is String)
				dataFormat = transDataFormat(dataFormat);
			
			var bytes:ByteArray = new ByteArray();
			return bytes;	
		}
		
		
		static public function decode(bytes:ByteArray,dataFormat:*):Object
		{
			if (dataFormat is String)
				dataFormat = transDataFormat(dataFormat);
			
			var o:Object = {};
			return o;
		}
		
		static public function transDataFormat(dataFormat:String):Object
		{
			var o:Object = {};
			var name:String;
			var value:String;
			var i:int = 0;
			
			name = "";
			value = "";
			while (i < dataFormat.length)
			{
				var ch:String = dataFormat.charAt(i);
				if (ch == "(")
				{
					var deep:int = 1;
					i++;
					while (i < dataFormat.length)
					{
						ch = dataFormat.charAt(i);
						if (ch == "(")
						{
							deep++;
						}
						else if (ch == ")")
						{
							deep--;
							if (deep == 0)
							{
								o[name] = transDataFormat(value);
								name = "";
								value = "";
								break;
							}
						}
						value = value + ch;
						i++;
					}
				}
				else if (ch == "[")
				{
					deep = 1;
					i++;
					while (i < dataFormat.length)
					{
						ch = dataFormat.charAt(i);
						if (ch == "[")
						{
							deep++;
						}
						else if (ch == "]")
						{
							deep--;
							if (deep == 0)
							{
								o[name] = [transDataFormat(value)];
								name = "";
								value = "";
								break;
							}
						}
						
						value = value + ch;
						i++;
					}
				}
				else
				{
					name = name + ch;
				}
				i++;
			}
			
			return value ? o : name;
		}
	}
}