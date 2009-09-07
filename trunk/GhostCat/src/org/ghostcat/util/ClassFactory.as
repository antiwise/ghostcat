package org.ghostcat.util
{
	import flash.utils.getDefinitionByName;

	/**
	 * 类工厂类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ClassFactory
	{
		/**
		 * 类
		 */
		public var generator : *;

		/**
		 * 类的初始属性
		 */
		public var properties : Object = null;
		
		public function ClassFactory (generator:* = null,properties:Object = null)
		{
			this.generator = generator;
			this.properties = properties;
		}

		/**
		 * 设置初始属性
		 *  
		 * @param key
		 * @param value
		 * 
		 */
		public function setProperties(key:String,value:*):void
		{
			if(!properties)
				properties = new Object();
		
			properties[key] = value;
		}
		
		/**
		 * 实例化 
		 * @return 
		 * 
		 */
		public function newInstance():*
		{
			if (generator is String)
				generator = getDefinitionByName(generator) as Class;
			
			var instance:* = new generator();
			
			if (properties)
			{
				for (var key : String in properties)
					if (instance.hasOwnProperty(key))
						instance[key] = properties[key];
			}
			return instance;
		}
	}
}
