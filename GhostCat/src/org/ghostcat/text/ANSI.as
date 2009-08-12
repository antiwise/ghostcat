package org.ghostcat.text
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
        	var arr:Array = unicodeToANSI(str);
        	var result:String = "";
        	for (var i:int = 0;i < arr.length;i++)
        	{
        		var data:int = arr[i];
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
        	var arr:Array = [];
        	var i:int = 0;
        	while (i < str.length)
        	{
        		var char:String = str.charAt(i);
        		var charCode:int = str.charCodeAt(i);
        		if (char!="%")
        			arr.push(charCode);
        		else
        		{
        			arr.push(parseInt(str.substr(i+1,2),16))
        			i+=2;
        		}
        		i++;
        	}
        	return ANSIToUnicode(arr);
        }
        
        /**
         * 将UTF8转换为gb2312
         * 
         * @param str	字符串
         * @return 
         * 由于flash中的字符串编码一定就是utf-8，所以返回值只能是数组
         * 
         */        
        public static function unicodeToANSI(str:String):Array
        {
        	var result:Array =[];
        	var temp:int;//缓存半个汉字
        	var byte:ByteArray =new ByteArray();
        	byte.writeMultiByte(str,"gb2312");
        	byte.position = 0;
        	for(var i:int = 0; i < byte.length;i++)
        	{	
        		var data:int = byte.readByte();
        		if ((data & 0xFF) == data)
        		{
        			result.push(data);
        			temp = 0;
        		}
        		else
        		{	
        			if (temp == 0)
        				temp = data & 0xFF;
        			else
        			{
        				result.push((temp << 8) | (data & 0xFF));
        				temp = 0;
        			}
        		}
        	}
        	return result;
        }
        
        /**
         * 将gb2312转换为UTF8
         * 
         * @param arr	ANSI字符值数组
         * @return 
         * 
         */        
        public static function ANSIToUnicode(arr:Array):String
        {
        	var byte:ByteArray =new ByteArray();
        	for(var i:int = 0; i < arr.length;i++)
        	{	
        		var data:int = arr[i];
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
  		public static function readTextFromByteArray(data:ByteArray):String
  		{
  			return data.readMultiByte(data.bytesAvailable, "gb2312");
  		}
  		
//  		/**
//  		 * 判断一个ByteArray里的数据是否是ANSI编码
//  		 * 
//  		 * @param data
//  		 * @return 
//  		 * 
//  		 */
//  		public static function isANSI(data:ByteArray):Boolean
//  		{
//  			if (data.length <= 2)
//  				return false;
//  			
//  			data.position = 0;
//  			var b0 : int = data.readUnsignedByte();
//   			var b1 : int = data.readUnsignedByte();
//   			data.position = 0;
//   			
//   			if (b0 == 0xFF && b1 == 0xFE ||//Unicode
//    			b0 == 0xFE && b1 == 0xFF ||//Unicode big endian
//    			b0 == 0xEF && b1 == 0xBB)//UTF-8
//    			return false;
//   			else
//   				return true;
//  		}
	}
}