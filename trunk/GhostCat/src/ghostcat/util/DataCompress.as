package ghostcat.util
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import ghostcat.text.TextUtil;
	
	/**
	 * 这个类提供了一些用于压缩数据的方法
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public final class DataCompress
	{
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