package org.ghostcat.util
{
	/**
	 * 处理XML对象序列化的操作
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class ReflectXMLUtil
	{
		/**
		 * 将对象转换为XML表示
		 * 
		 * @param v	对象
		 * @return 
		 * 
		 */
		public static function objectToXML(v:*):XML
		{
			var key:*;
			var result:XML = new XML();
			result.setName(ReflectUtil.getQName(v));
			
			var obj:Object = Util.unionObject(v,ReflectUtil.getPropertyList(v));
			for (key in obj)
				result["@"+key] = obj[key];
			return result;
		}
		
		/**
		 * 根据XML设置对象属性
		 * 
		 * @param obj	对象
		 * @param key	键
		 * @param value	值
		 * @param root	执行此方法的对象，是反射外部属性的依据。缺省为obj本身。
		 */
		public static function setPropertyByXML(obj:*,key:String,value:XML,root:*=null):void
		{
			if (!root)
				root = obj;
				
			if (new RegExp("^{.*}$").test(value))
			{
				var prop:String = value.toString().substring(1,value.toString().length - 1);
				obj[key] = root[prop];
			}
			else
			{	
				var propClass:Class = ReflectUtil.getTypeByProperty(obj,key);
				switch (propClass)
				{
					case Boolean:
						obj[key] = (value == "true");
						break;
					case Class:
						obj[key] = ReflectUtil.getDefinitionByName(value) as Class;
						break;
					default:
						obj[key] = value.toString();
						break;
				}
			}
		}
		
		/**
		 * 将XML转换为相应对象
		 * 
		 * @param v	XML对象
		 * @param root	执行此方法的对象，是反射外部属性的依据。缺省为obj本身。
		 * @return 
		 * 
		 */
		public static function XMLToObject(v:XML,root:*=null):Object
		{
			var target:*;
			try
			{
				var ref:Class = ReflectUtil.getDefinitionByName(v.name().toString()) as Class;
				target = new ref();
			}
			catch (e:Error)
			{
				target = new Object();
			}
			parseXML(v,target,root);
			return target;
		}
		
		/**
		 * 将XML的属性粘贴到原有对象
		 * 
		 * @param v	XML对象
		 * @param target	原有对象
		 * @param root	执行此方法的对象，是反射外部属性的依据。缺省为obj本身。
		 * @return 
		 * 
		 */
		public static function parseXML(v:XML,target:*,root:*=null):void
		{
			var source:XMLList = v.attributes();
			for (var i:int = 0; i < source.length(); i++)
			{
				setPropertyByXML(target,source[i].name(),source[i],root);
			}
		}
	}
}