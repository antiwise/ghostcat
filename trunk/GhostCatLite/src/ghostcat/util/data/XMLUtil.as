package ghostcat.util.data
{
	import flash.utils.ByteArray;
	
	import ghostcat.debug.Debug;

	/**
	 * XML辅助类 
	 * @author flashyiyi
	 * 
	 */
	public final class XMLUtil
	{
		public static function createFrom(source:*):XML
		{
			if (source is Class)
				source = new source();
			
			if (source is ByteArray)
			{
				try
				{
					(source as ByteArray).uncompress();
				}
				catch (e:Error)
				{}
				source = source.toString();
			}
			
			if (source is String)
			{
				while (source.substr(0,1) != "<") //去掉额外的文件首字符
					source = source.substr(1);
				return new XML(source);
			}
			else
				Debug.error("不支持的类型");
			return null;
		}
		
		public static function attributesToObject(xml:XML,result:Object = null):Object
		{
			if (!result)
				result = new Object();
			
			for each (var xml:XML in xml.attributes())
				result[xml.name().toString()] = xml.toString();
			
			return result;
		}
		
		public static function objectToAttributes(obj:Object,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for (var key:String in obj)
				result["@"+key] = obj[key];
			
			return result;
		}
		
		public static function childrenToAttributes(obj:XML,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for each (var xml:XML in obj.children())
				result["@" + xml.name().toString()] = xml.toString();
			
			return result;
		}
		
		public static function attributesToChildren(obj:XML,result:XML = null):XML
		{
			if (!result)
				result = <xml/>;
			
			for each (var xml:XML in obj.attributes())
			{
				var child:XML = <xml/>
				child.setName(xml.name());
				child.appendChild(xml.toString());
				result.appendChild(child);
			}
			return result;
		}
	}
}