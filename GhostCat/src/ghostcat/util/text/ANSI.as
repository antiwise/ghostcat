package ghostcat.util.text
{
	import flash.utils.ByteArray;

	/**
	 * 一些处理编码的方法。目前只有关于ANSI的。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public final class ANSI
	{
		/**
         * 将UTF8转换为gb2312的URL字符串，主要应付一些不支持unicode码的服务器，诸如百度- -
         * 
         * @param str	字符串
         * @return 
         * 
         */        
        public static function escapeByANSI(str:String):String
        {
        	var arr:String = unicodeToANSI(str);
        	var result:String = "";
        	for (var i:int = 0;i < arr.length;i++)
        	{
        		var data:int = arr.charCodeAt(i);
        		if (data <= 0xFF)
        			result += escape(String.fromCharCode(data));
        		else
        			result += "%"+ (data >> 8).toString(16).toUpperCase() +
        					"%"+ (data & 0xFF).toString(16).toUpperCase();
        	}
        	return result;
        }
        
        /**
         * escapByANSI的逆运算
         * 
         * @param str	ANSI URL字符串
         * @return 
         * 
         */
        public static function unescapeFromANSI(str:String):String
        {
        	var arr:String = "";
        	var i:int = 0;
        	while (i < str.length)
        	{
        		var char:String = str.charAt(i);
        		var charCode:int = str.charCodeAt(i);
        		if (char!="%")
				{
        			arr = arr + String.fromCharCode(charCode);
				}
				else
        		{
					arr = arr + String.fromCharCode(parseInt(str.substr(i+1,2),16));
        			i+=2;
        		}
        		i++;
        	}
        	return ANSIToUnicode(arr);
        }
        
        /**
         * 将UTF8转换为gb2312
         * 
         * @param str	UTF8字符串
         * @return 一个ANSI字符串
         * 
         */        
        public static function unicodeToANSI(str:String):String
        {
        	var result:String = "";
        	var temp:int;//缓存半个汉字
        	var byte:ByteArray =new ByteArray();
        	byte.writeMultiByte(str,"gb2312");
        	byte.position = 0;
        	for(var i:int = 0; i < byte.length;i++)
        	{	
        		var data:int = byte.readByte();
        		if ((data & 0xFF) == data)
        		{
        			result = result + String.fromCharCode(data);
        			temp = 0;
        		}
        		else
        		{	
        			if (temp == 0)
					{
        				temp = data & 0xFF;
					}
					else
        			{
						result = result + String.fromCharCode((temp << 8) | (data & 0xFF));
        				temp = 0;
        			}
        		}
        	}
        	return result;
        }
        
        /**
         * 将gb2312转换为UTF8
         * 
         * @param str	ANSI字符串
         * @return	一个UTF8的字符串
         * 
         */        
        public static function ANSIToUnicode(str:String):String
        {
        	var byte:ByteArray = new ByteArray();
			var l:int = str.length;
        	for(var i:int = 0; i < l;i++)
        	{	
        		var data:int = str.charCodeAt(i);
        		if ((data & 0xFF) == data)
        		{
        			byte.writeByte(data);
        		}
        		else
        		{	
        			byte.writeByte(data >> 8);
        			byte.writeByte(data & 0xFF);
        		}
        	}
        	byte.position = 0;
        	return byte.readMultiByte(byte.bytesAvailable,"gb2312");
        }
        
        /**
  		 * 从ByteArray中读取ANSI编码文本
  		 */
  		public static function readTextFromByteArray(data:ByteArray,charSet:String = "gb2312"):String
  		{
  			return data.readMultiByte(data.bytesAvailable, charSet);
  		}
  		
  		/**
  		 * 获得一个字符串在ANSI码中的长度（中文长度为2）
  		 * 
  		 * @param data	字符串
  		 * @return 
  		 * 
  		 */
  		public static function getLength(data:String):int
  		{
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte(data,"gb2312");
			return byte.length;
  		}
	}
}