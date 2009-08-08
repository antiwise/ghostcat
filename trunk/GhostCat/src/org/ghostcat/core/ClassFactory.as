package org.ghostcat.core
{
	public class ClassFactory
	{
		public var generator : Class;

		public var properties : Object = null;
		
		public function ClassFactory (generator:Class = null,properties:Object = null)
		{
			this.generator = generator;
			this.properties = properties;
		}

		public function setProperties(key:String,value:*):void
		{
			if(!properties)
				properties = new Object();
		
			properties[key] = value;
		}
		
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
