package ghostcat.util.core
{
	import flash.errors.IllegalOperationError;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * 实现抽象类的辅助方法
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class AbstractUtil
	{
		/**
		 * 阻止抽象类的实例化
		 * 
		 * @param obj	对象
		 * @param AbstractType	抽象类类型
		 * 
		 */
		public static function preventConstructor(obj:*,abstractType:Class,errorText:String = null):void
		{
			if (obj["constructor"] == abstractType)  
			{
				if (!errorText)
				{
					var typeName:String = getQualifiedClassName(obj);
					errorText = typeName+" 类为抽象类，不允许实例化!";
				}
				throw new IllegalOperationError(errorText);
			}
		}
		
		/**
		 * 要求必须实现抽象类的虚方法
		 *  
		 * @param obj	对象
		 * @param AbstractType	抽象类类型
		 * @param unimplemented	必须实现的虚方法列表（一个数组，里面是方法的名称）
		 * 
		 */
		public static function mustBeOverridden(obj:*,abstractType:Class,unimplemented:Array):void
		{
			var typeName:String = getQualifiedClassName(abstractType);
			var concreteTypeName:String = getQualifiedClassName(obj);
			
			var des:XML = describeType(obj);
			
			var item:XML;
			var methods:XMLList = des..method.(@declaredBy == typeName && unimplemented.indexOf(@name.toString()) != -1);
			for each (item in methods)
			{
				throw new IllegalOperationError("虚方法 " + item.@name + " (位于命名空间 " + typeName + " 中)未由类 " + concreteTypeName + " 实现。");
			}
			
			var accessors:XMLList = des..accessor.(@declaredBy == typeName && unimplemented.indexOf(@name.toString()) != -1);
			for each (item in accessors)
			{
				throw new IllegalOperationError("存取器 " + item.@name + " (位于命名空间 " + typeName + " 中)未由类 " + concreteTypeName + " 实现。");
			}
        }
	}
}



                