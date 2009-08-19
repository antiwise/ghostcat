package org.ghostcat.core
{
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
		public var generator : Class;

		/**
		 * 类的初始属性
		 */
		public var properties : Object = null;
		
		public function ClassFactory (generator:Class = null,properties:Object = null)
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
