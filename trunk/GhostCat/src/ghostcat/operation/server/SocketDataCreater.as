package ghostcat.operation.server
{
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

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
	 *  	
	 *  BOOL 表示 true
	 *  p(BOOL)表示{p:true}
	 *  x(I32)y(I32)表示{x:0,y:0}
	 *  [I32]表示[0,1,3,4]
	 *  p[I32]表示{p:[0,1,3,4]}
	 *  [x(I32)y(I32)]表示[{x:0,y:0},{x:1,y:1}]
	 *  x(x(I32))表示{x:{x:0}}
	 *  [[I32]]表示[[1,2],[3,4]]
	 * 
	 * 	在属性名后或者类型标记前增加<flash.geom::Point>可以在反序列化时自动转换为自定义类，诸如
	 *  p<flash.geom::Point>(x(I32)y(I32))表示{p:new Point(1,2)}
	 *  <flash.geom::Point>(x(I32)y(I32)) 表示new Point(1,2)
	 *  [<flash.geom::Point>(x(I32)y(I32))] 表示[new Point(1,2),new Point(3,4)]
	 */
	
	public final class SocketDataCreater
	{
		/**
		 * 编码 
		 * @param obj
		 * @param dataFormat
		 * @return 
		 * 
		 */
		static public function encode(obj:Object,dataFormat:*):ByteArray
		{
			if (dataFormat is String)
				dataFormat = conversionDataFormat(dataFormat);
			
			var bytes:ByteArray = new ByteArray();
			encodeFunction(obj,dataFormat,bytes);
			bytes.position = 0;
			return bytes;	
		}
		
		static private function encodeFunction(obj:Object,dataFormat:*,bytes:ByteArray):void
		{
			if (dataFormat is String)
			{
				switch (dataFormat)
				{
					case "BOOL":
						bytes.writeBoolean(obj as Boolean);
						break;
					case "U8":
					case "I8":
						bytes.writeByte(int(obj));
						break;
					case "U16":
					case "I16":
						bytes.writeShort(int(obj));
						break;
					case "U32":
						bytes.writeUnsignedInt(int(obj));
						break;
					case "I32":
						bytes.writeInt(int(obj));
						break;
					case "F32":
						bytes.writeFloat(Number(obj));
						break;
					case "F64":
						bytes.writeDouble(Number(obj));
						break;
					case "UTF":
						bytes.writeUTF(String(obj));
						break;
					case "MB":
						if (obj)
						{
							bytes.writeUnsignedInt((obj as ByteArray).length)
							bytes.writeBytes(obj as ByteArray);
						}
						else
						{
							bytes.writeUnsignedInt(0);
						}
						break;
				}
			}
			else if (dataFormat is Array)
			{
				var list:Array = obj as Array;
				if (!list)
					list = [];
				bytes.writeUnsignedInt(list.length);
				for (var i:int = 0; i < list.length;i++)
				{
					encodeFunction(list[i],dataFormat[0],bytes);
				}
			}
			else
			{
				for (var p:String in dataFormat)
				{
					var name:String = p;
					var index:int = name.indexOf("<");
					if (index != -1 && name.charAt(name.length - 1) == ">")
						name = name.slice(0,index);
					
					encodeFunction(name ? obj[name] : obj,dataFormat[p],bytes);
				}
			}
		}
		
		/**
		 * 解码 
		 * @param bytes
		 * @param dataFormat
		 * @param cls	根表示的类
		 * @return 
		 * 
		 */
		static public function decode(bytes:ByteArray,dataFormat:*,cls:Class = null):Object
		{
			if (dataFormat is String)
				dataFormat = conversionDataFormat(dataFormat);
			
			return decodeFunction(bytes,dataFormat,cls);
		}
		
		static private function decodeFunction(bytes:ByteArray,dataFormat:*,cls:Class = null):*
		{
			if (dataFormat is String)
			{
				switch (dataFormat)
				{
					case "BOOL":
						return bytes.readBoolean();
					case "U8":
						return bytes.readUnsignedByte();
					case "I8":
						return bytes.readByte();
					case "U16":
						return bytes.readUnsignedShort();
					case "I16":
						return bytes.readShort();
					case "U32":
						return bytes.readUnsignedInt();
					case "I32":
						return bytes.readInt();
					case "F32":
						return bytes.readFloat();
					case "F64":
						return bytes.readDouble();
					case "UTF":
						return bytes.readUTF();
					case "MB":
						var len:int = bytes.readUnsignedInt();
						var newBytes:ByteArray = new ByteArray();
						bytes.readBytes(newBytes,0,len);
						return newBytes;
				}
			}
			else if (dataFormat is Array)
			{
				len = bytes.readUnsignedInt();
				var list:Array = [];
				for (var i:int = 0; i < len;i++)
				{
					list[i] = decodeFunction(bytes,dataFormat[0]);
				}
				return list;
			}
			else
			{
				var obj:Object = cls ? new cls() : {};
				for (var p:String in dataFormat)
				{
					var name:String = p;
					var childRef:Class = null;
					var index:int = name.indexOf("<");
					if (index != -1 && name.charAt(name.length - 1) == ">")
					{
						name = name.slice(0,index);
						childRef = getDefinitionByName(p.slice(index + 1,p.length - 1)) as Class
					}
					var child:* = decodeFunction(bytes,dataFormat[p],childRef);
					if (name)
						obj[name] = child;
					else
					{
						obj = child;
						break;
					}
				}
				return obj;
			}
			return null;
		}
		
		/**
		 * 将字符串转换中间需要的协议格式，这个结果也可以代替字符串使用 
		 * @param dataFormat
		 * @return 
		 * 
		 */
		static public function conversionDataFormat(dataFormat:String):Object
		{
			var o:Object;
			var name:String;
			var value:String;
			
			var child:*;
			
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
								child = conversionDataFormat(value);
								if (!o)
									o = {};
								
								if (name)
									o[name] = child;
								else
									o = child;
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
								child = [conversionDataFormat(value)];
								if (!o)
									o = {};
								
								if (name)
									o[name] = child;
								else
									o = child;
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
			
			return o ? o : name;
		}
	}
}