package org.ghostcat.util
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.ghostcat.text.TextUtil;
	
	/**
	 * 这个类提供了一些用于压缩数据的方法
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public final class DataCompress
	{
		private static var hashDict:Dictionary = new Dictionary();
		
		/**
		 * 将一个字符串转成对应的Hash码，一般作为物品的类型ID使用。比起按顺序的ID递增，这种方法在XML脚本里更易于使用。
		 * 
		 * 32位的Hash算法- -，这种方法必然会产生碰撞。但在实际应用中，超过1000个物品使用了这种方法，碰撞并没有发生。而使用一个长度为8的随机字符串检测，
		 * 在15秒的超时范围内生成了100万条数据，依然没有发生碰撞。
		 * 
		 * 所以这种方法是相对可靠的。
		 * 
		 * @param s	要转换的字符串
		 * @param checkDup	是否检测重复
		 * 它需要将所有计算出来的Hash码保存起来，会占用大量的内存资源。请只在检测hash碰撞的时候使用。
		 * @param startValue	起始值，一般为0。
		 * @return 
		 * 
		 */		
		public static function hashFromString(s:String, checkDup:Boolean = false, startValue:uint=0):uint
        {
            var len:int = s.length;
            var seed:uint = 2654435769;
            var value:uint = seed;
            var returnValue:uint = startValue;
            var tmp:String = s;
            while (len >= 12) 
            {
                seed = seed + uint(tmp.charCodeAt(0) + (uint(tmp.charCodeAt(1)) << 8) 
                	+ (uint(tmp.charCodeAt(2)) << 16) + (uint(tmp.charCodeAt(3)) << 24));
                value = value + uint(tmp.charCodeAt(4) + (uint(tmp.charCodeAt(5)) << 8) 
                	+ (uint(tmp.charCodeAt(6)) << 16) + (uint(tmp.charCodeAt(7)) << 24));
                returnValue = returnValue + uint(tmp.charCodeAt(8) + (uint(tmp.charCodeAt(9)) << 8) 
                	+ (uint(tmp.charCodeAt(10)) << 16) + (uint(tmp.charCodeAt(11)) << 24));
                seed = (seed = (seed = seed - value) - returnValue) ^ returnValue >> 13;
                value = (value = (value = value - returnValue) - seed) ^ seed << 8;
                returnValue = (returnValue = (returnValue = returnValue - seed) - value) ^ value >> 13;
                seed = (seed = (seed = seed - value) - returnValue) ^ returnValue >> 12;
                value = (value = (value = value - returnValue) - seed) ^ seed << 16;
                returnValue = (returnValue = (returnValue = returnValue - seed) - value) ^ value >> 5;
                seed = (seed = (seed = seed - value) - returnValue) ^ returnValue >> 3;
                value = (value = (value = value - returnValue) - seed) ^ seed << 10;
                returnValue = (returnValue = (returnValue = returnValue - seed) - value) ^ value >> 15;
                len = len - 12;
                tmp = tmp.substr(12);
            }
            returnValue = returnValue + 1;
            switch (len) 
            {
                case 11:
                    returnValue = returnValue + (uint(tmp.charCodeAt(10)) << 24);
                case 10:
                    returnValue = returnValue + (uint(tmp.charCodeAt(9)) << 16);
                case 9:
                    returnValue = returnValue + (uint(tmp.charCodeAt(8)) << 8);
                case 8:
                    value = value + (uint(tmp.charCodeAt(7)) << 24);
                case 7:
                    value = value + (uint(tmp.charCodeAt(6)) << 16);
                case 6:
                    value = value + (uint(tmp.charCodeAt(5)) << 8);
                case 5:
                    value = value + uint(tmp.charCodeAt(4));
                case 4:
                    seed = seed + (uint(tmp.charCodeAt(3)) << 24);
                case 3:
                    seed = seed + (uint(tmp.charCodeAt(2)) << 16);
                case 2:
                    seed = seed + (uint(tmp.charCodeAt(1)) << 8);
                case 1:
                    seed = seed + uint(tmp.charCodeAt(0));
            }
            seed = (seed = (seed = seed - value) - returnValue) ^ returnValue >> 13;
            value = (value = (value = value - returnValue) - seed) ^ seed << 8;
            returnValue = (returnValue = (returnValue = returnValue - seed) - value) ^ value >> 13;
            seed = (seed = (seed = seed - value) - returnValue) ^ returnValue >> 12;
            value = (value = (value = value - returnValue) - seed) ^ seed << 16;
            returnValue = (returnValue = (returnValue = returnValue - seed) - value) ^ value >> 5;
            seed = (seed = (seed = seed - value) - returnValue) ^ returnValue >> 3;
            value = (value = (value = value - returnValue) - seed) ^ seed << 10;
            returnValue = (returnValue = (returnValue = returnValue - seed) - value) ^ value >> 15;
            return returnValue;
            
            if (checkDup)
            {
            	if (hashDict[returnValue] && hashDict[returnValue]!=s)
            		throw new Error("Hash碰撞发生！'" + s + "'与'" +  hashDict[returnValue] + "'的hash码都是" + returnValue)
            	else
            		hashDict[returnValue] = s;
            }
            
            return returnValue;
        }
        
        /**
         * 将一个对象复制到ByteArray中
         * 空值是一个16位数值0，和空字符串统一
         * 
         * @param obj	对象
         * @param bytes	内存块
         * 
         */        
        public static function copyToByteArray(obj:*,bytes:ByteArray):void
        {
        	if (obj == null)
        		bytes.writeShort(0);
        	else if (obj is String)
        		bytes.writeUTF(obj);
        	else if (obj is Boolean)
        		bytes.writeBoolean(obj);
        	else if (obj is int)
        		bytes.writeInt(obj);
        	else if (obj is uint)
        		bytes.writeUnsignedInt(obj);
        	else if (obj is Number)
        		bytes.writeDouble(obj);
        	else if (obj is Array)
        	{
        		bytes.writeShort(obj);
        		for (var i:int = 0; i < obj.length;i++)
        			copyToByteArray(obj[i],bytes);
        	}
        	else
        	{
        		var v:Object = Util.unionObject(obj,ReflectUtil.getPropertyList(obj));
        		for (var key:* in v)
        			copyToByteArray(v[key],bytes);
        	}
        }
        
        /**
         * 获得对象的结构，供后端解析时参考
         * 
         * 作为参数的对象应当没有空值，否则无法判断类型。数组也应当具有统一类型且有内容。
         * 
         * @param obj
         * @return 
         * 
         */        
        public static function copyToByteArrayHelper(obj:*,level:int=0):String
        {
        	var res:String = "";
        	
        	if (obj == null)
        		res+= "<null>";
        	else if (obj is String)
        		res+= "<String>";
        	else if (obj is Boolean)
        		res+= "<Boolean>";
        	else if (obj is int)
        		res+= "<Int>";
        	else if (obj is uint)
        		res+= "<UnsignedInt>";
        	else if (obj is Number)
        		res+= "<Double>";
        	else if (obj is Array)
        	{
        		res+="[<Short>";
        		if (obj.length>0)
        			res+=copyToByteArrayHelper(obj[0]);
        		else
        			res+="<null>"
        		res+="...]";
        	}
        	else
        	{
        		res+="\n"+ TextUtil.fillZeros("",level,"\t") + "{\n";
        		var v:Object = Util.unionObject(obj,ReflectUtil.getPropertyList(obj));
        		for (var key:* in v)
        		{
        			res+=TextUtil.fillZeros("",level+1,"\t") + key + ":";
        			res+=copyToByteArrayHelper(v[key],level+1);
        		}
        		res+=TextUtil.fillZeros("",level,"\t") + "}";
        	}
        	res+="\n";
        	return res;
        }
        
        /**
         * 将数据转换为二维表的形式，避免因为重复键值大量浪费带宽
         */
        public static function transToTable(source:Array):Array
        {
        	if (source.length == 0)
        		return [];
        	
        	var result:Array = [];
        	var key:*;
        	var arr:Array;
        	arr = [];
        	for (key in source[0])
        		arr.push(key);
        	result.push(arr);
        	
        	for (var i:int = 0; i < source.length; i++)
        	{
        		arr = [];
        		var data:Object = source[i];
        		for (key in data)
        			arr.push(data[key]);
        		result.push(arr);	
        	}
        	return result;
        }
        
        /**
         * 将数据由二维表转换为对象数组的形式
         */
        public static function transFromTable(source:Array):Array
        {
        	if (source.length <= 1)
        		return [];
        	
        	var result:Array = [];
        	for (var i:int = 1; i < source.length; i++)
        	{
        		var data:Object = new Object();
        		for (var j:int = 0;j < source[i].length;j++)
        			data[source[0][j]] = source[i][j];
        		result.push(data);	
        	}
        	return result;
        }
	}
}