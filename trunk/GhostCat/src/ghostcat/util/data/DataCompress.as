package ghostcat.util.data
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import ghostcat.text.NumberUtil;
	import ghostcat.text.TextUtil;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.Util;

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
        		res += "<null>";
        	else if (obj is String)
        		res += "<String>";
        	else if (obj is Boolean)
        		res += "<Boolean>";
        	else if (obj is int)
        		res += "<Int>";
        	else if (obj is uint)
        		res += "<UnsignedInt>";
        	else if (obj is Number)
        		res += "<Double>";
        	else if (obj is Array)
        	{
        		res += "[<Short>";
        		if (obj.length>0)
        			res += copyToByteArrayHelper(obj[0]);
        		else
        			res += "<null>"
        		res += "...]";
        	}
        	else
        	{
        		res += "\n" + NumberUtil.fillZeros("",level,"\t") + "{\n";
        		var v:Object = Util.unionObject(obj,ReflectUtil.getPropertyList(obj));
        		for (var key:* in v)
        		{
        			res += NumberUtil.fillZeros("",level+1,"\t") + key + ":";
        			res += copyToByteArrayHelper(v[key],level+1);
        		}
        		res += NumberUtil.fillZeros("",level,"\t") + "}";
        	}
        	res+="\n";
        	return res;
        }
	}
}