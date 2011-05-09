package ghostcat.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.util.core.ClassFactory;

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
			var result:XML = <xml/>;
			result.setName(ReflectUtil.getQName(v));
			
			var obj:Object = Util.unionObject(v,ReflectUtil.getPropertyList(v));
			for (key in obj)
				result["@"+key] = obj[key];
			return result;
		}
		
		/**
		 * 根据属性类型设置对象属性
		 * 
		 * @param obj	对象
		 * @param key	键
		 * @param value	值
		 * @param root	执行此方法的对象，是反射外部属性的依据。缺省为obj本身。
		 */
		public static function setProperty(obj:*,key:String,value:*,root:*=null,enabledReflect:Boolean = true):void
		{
			if (!root)
				root = obj;
				
			if (enabledReflect && new RegExp("^{.*}$").test(value.toString()))
			{
				var prop:String = value.toString().substring(1,value.toString().length - 1);
				obj[key] = ReflectUtil.eval(prop,root);
			}
			else
			{	
				var propClass:Class = ReflectUtil.getTypeByProperty(obj,key);
				switch (propClass)
				{
					case Boolean:
						obj[key] = (value == "true" || value == true);
						break;
					case Class:
						obj[key] = ReflectUtil.getDefinitionByName(value.toString()) as Class;
						break;
					case Function:
						obj[key] = ReflectUtil.eval(value) as Function;
						break;
					case uint:
					case int:
					case Number:
						if ((/^#[\dabcdef]+$/i).test(value))
							value = "0x"+(value as String).substr(1)
						obj[key] = value;
						break;
					default:
						obj[key] = value;
						break;
				}
			}
		}
		
		/**
		 * 将XML转换为相应对象
		 * 
		 * @param v	XML对象
		 * @param root	执行此方法的对象，是反射外部属性的依据。缺省为obj本身。
		 * @param constructor 构造函数参数
		 * @return 
		 * 
		 */
		public static function XMLToObject(v:XML,root:*=null,constructor:Array=null,enabledReflect:Boolean = true):Object
		{
			var target:*;
			
			var ref:Class = ReflectUtil.getDefinitionByName(v.name().toString()) as Class;
			
			target = ClassFactory.apply(ref,constructor);
			parseXML(v,target,root,enabledReflect);
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
		public static function parseXML(v:XML,target:*,root:*=null,enabledReflect:Boolean = true):void
		{
			var source:XMLList = v.attributes();
			for (var i:int = 0; i < source.length(); i++)
			{
				setProperty(target,source[i].name(),source[i].toString(),root,enabledReflect);
			}
		}
		
		/**
		 * 获得子对象树
		 *  
		 * @param displayObj
		 * @return 
		 * 
		 */
		public static function getChildXML(v:DisplayObject,filterClass:Class = null):XML
		{
			var result:XML = <xml/>;
			result.setName(ReflectUtil.getQName(v));
			result.@name = v.name;
			result.@x = v.x;
			result.@y = v.y;
			
            if (v is DisplayObjectContainer)
            {
                var contain:DisplayObjectContainer = DisplayObjectContainer(v);
                for (var i:int=0;i < contain.numChildren;i++) 
				{
					var child:DisplayObject = contain.getChildAt(i);
					if (!filterClass || (child is filterClass))
						result.appendChild(getChildXML(child,filterClass));
				}
			}
            return result;
        }
		
		/**
		 * 是简单类型
		 * @param v
		 * @return 
		 * 
		 */
		public static function isSimpleClass(name:String):Boolean
		{
			return name == "String" || name == "Number" || name == "Boolean" || name == "Array"
		}
	}
}