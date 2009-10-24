package ghostcat.util
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.debug.Debug;

	/**
	 * 反射管理类
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class ReflectUtil
	{
		private static var describeTypeCache:Dictionary = new Dictionary(true);
		
		/**
		 * 获取类和对象的详细属性
		 * 
		 * @param obj	对象
		 * @param cache	是否缓存，供下次快速调用
		 * @return 
		 * 
		 */		
		public static function getDescribeType(obj:*,cache:Boolean=true):XML
		{
			obj = getClass(obj);
			var xml:XML;
			if (describeTypeCache.hasOwnProperty(obj))
			{
				xml = describeTypeCache[obj];
			}
			else
			{
				xml = describeType(obj);
				if (cache) 
					describeTypeCache[obj] = xml;
			}
			return xml;
		}
		
		/**
		 * 清除缓存
		 * 
		 * @param obj 清空某个指定的对象，取默认值则清空全部
		 */		
		public static function clearDescribeTypeCache(obj:*=null):void
		{
			if (obj)
			{
				delete describeTypeCache[obj];
			}
			else
			{
				describeTypeCache = new Dictionary(true);
			}
		}
		
		/**
		 * 获得方法列表
		 * 
		 * @param obj	对象
		 * @return 
		 * 
		 */		
		public static function getMethodList(obj:*):Object
		{
			var xml:XML;
			var child:XML;
			var name:String;
			var result:Object;
			
			xml = getDescribeType(obj);
			result = new Object();
			
			for each(child in xml..method){
				name = child.@name.toString();
				result[name] = obj[name];
			}
						
			return result;
		}
		
		/**
		 * 取得属性列表
		 * 
		 * @param obj	对象
		 * @param writeable	是否必须可读
		 * @return 
		 * 
		 */
		public static function getPropertyList(obj:*,writeable:Boolean=false):Object
		{
			var xml:XML;
			var child:XML;
			var name:String;
			var result:Object;
			
			xml = getDescribeType(obj);
			result = new Object();
			
			for each(child in xml..accessor)
			{
				if (child.@access=="readonly" && writeable)
					continue;
				name = child.@name.toString();
				if (obj.hasOwnProperty(name))
					result[name] = obj[name];
			}
			for each(child in xml..variable)
			{
				name = child.@name.toString();
				result[name] = obj[name];
			}
			return result;
		}
		
		/**
		 * 获得对象某个属性的类型。这个类型和属性的值无关。只有通过它才能获得属性未赋值时的类型。
		 * 
		 * @param obj	对象
		 * @param property	属性名
		 * @return 
		 * 
		 */
		public static function getTypeByProperty(obj:*,property:String):Class
		{
			var xml:XML = getDescribeType(obj);
			var result:XMLList = xml..*.accessor.(@name==property);
			if (result.length()>0)
				return getDefinitionByName(result[0].@type) as Class;
			result = xml..*.variable.(@name==property);
			if (result.length()>0)
				return getDefinitionByName(result[0].@type) as Class;
			return null;
		}
		
		/**
		 * 取得全部属性的类型
		 * 
		 * @param obj	对象
		 * @param writeable	是否必须可读
		 * @return 
		 * 
		 */
		public static function getPropertyTypeList(obj:*,writeable:Boolean=false):Object
		{
			var xml:XML;
			var child:XML;
			var name:String;
			var result:Object;
			
			xml = getDescribeType(obj);
			result = new Object();
			
			for each(child in xml..accessor)
			{
				if (child.@access=="readonly" && writeable)
					continue;
				name = child.@name.toString();
				if (obj.hasOwnProperty(name))
					result[name] = getDefinitionByName(child.@type);
			}
			for each(child in xml..variable)
			{
				name = child.@name.toString();
				result[name] = getDefinitionByName(child.@type);
			}
			return result;
		}
		
		/**
		 * 通过点操作符查找函数
		 * 显示对象的[]操作符可以用来查询子对象
		 * 
		 * 诸如eval("items[0].panel.buttonBar[2].text",root)
		 * 
		 * 如果第一段像一个类名的话，将会自动反射，此时root属性将会无效化。
		 * 诸如：eval("ghostcat.util::Queue.defaultQueue.commit")();
		 * 
		 * @param path	路径
		 * @param root	起始对象
		 * 
		 * 
		 * @return 
		 * 
		 */		
		public static function eval(value:String,root:Object=null):*
		{	
			//如果写了包名则反射root
			var si:int = value.indexOf("::");
			var li:int;
			if (si != -1)
			{
				li = value.indexOf(".",si);
				if (li == -1)
					li = value.length;
				root = getDefinitionByName(value.substr(0,li));
				value = value.substr(li);
			}
			
			var paths:Array = value.split(/\[|\]|\./);
			try
			{
				if (value.charAt(0) > "A" && value.charAt(0) < "Z")
					root = getDefinitionByName(paths.shift());//处理没有写包名的情况
					
				for each (var path:String in paths)
				{
					if (!root)
						return null;
					
					if (path == "")
						continue;
					
					var num:Number = Number(path);
					if(isNaN(num))
						root = root[path];
					else
						root = (root is DisplayObjectContainer)?root.getChildAt(int(num)):root[num];
				}
			}
			catch (e:Error)
			{
				Debug.trace("REF","反射失败！ReflectManager.eval() "+e.message);
				return null;
			}
			return root;
		}
		
		/**
		 * 由字符串获得类型。这个方法并不会报错，而以生成trace消息代之。
		 * 
		 * @param name	对象名称
		 * @return 
		 * 
		 */		
		public static function getDefinitionByName(name:String):Class
		{
			if (name == "*")
				name = "Object";
				
			try{
				return flash.utils.getDefinitionByName(name) as Class;
			}catch (e:ReferenceError){
				Debug.trace("REF","反射类"+name+"失败！");
			}
			return null;
		}
		
		/**
		 * 获取一个类的特定属性下的MetaData
		 * 
		 * MetaData属于编译期标签，大部分将会在编译后被删除。
		 * 如果要保留MetaData供这个方法读取的话，则需要在编译参数上加上-keep-as3-metadata+=xxx
		 * 
		 * @param obj	对象
		 * @param property	属性名称，为空则为类
		 * @param metaName	元标签的名称，为空则是第一个
		 * @return 
		 * 
		 */
		public static function getMetaData(obj:*,property:String=null,metaName:String=null):XML
		{
			var xml:XML = getDescribeType(obj);	
			var prop:XML;
			if (property == null)
				prop = xml.factory[0];
			else
				prop = xml..*.(hasOwnProperty("@name") && @name == property)[0];
			
			if (prop)
			{
				if (metaName)
					return prop.metadata.(@name == metaName)[0];
				else
					return prop.metadata[0];
			}
			return null;	
		}
		
		/**
		 * 获取对象所属的类
		 * 当对象本身即是类时，返回自身
		 * 
		 * @param obj
		 * @return 
		 */
		public static function getClass(obj:*):Class
		{	
			if (obj == null)
				return null;
			else if (obj is Class)
				return obj;
			else	
				return obj.constructor as Class;
		}
		
		/**
		 * 获得当前对象的QName（包含类名和包名）
		 * 
		 * @param obj	对象
		 * 
		 */
		public static function getQName(obj:*):QName
		{
			var names:Array = getQualifiedClassName(obj).split("::");
			if (names.length == 2)
				return new QName(names[0],names[1]);
			else
				return new QName(null,names[0]);
			
			return null;
		}
	}
}