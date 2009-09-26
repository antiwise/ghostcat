package ghostcat.util
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
		
		/**
		 * 类的构造函数参数
		 */		
		public var params : Array = null
		
		public function ClassFactory (generator:* = null,properties:Object = null,params:Array = null)
		{
			this.generator = generator;
			this.properties = properties;
			this.params = params;
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
			if (!generator)
				return null;
				
			if (generator is String)
				generator = getDefinitionByName(generator) as Class;
			
			var instance:*;
			if (params && params.length > 0 ) 
				instance = (applyFuns[params.length] as Function)(generator,params);
			else
				instance = new generator();
			
			if (properties)
			{
				for (var key : String in properties)
					if (instance.hasOwnProperty(key))
						instance[key] = properties[key];
			}
			return instance;
		}
		
		/**
		 * 判断是否是这个类型
		 * 
		 * @param obj
		 * @return 
		 * 
		 */
		public function isClass(obj:*):Boolean
		{
			if (!generator)
				return false;
				
			if (generator is String)
				generator = getDefinitionByName(generator) as Class;
				
			return obj is generator;
		}
		
		/**
		 * 用参数数组来构造类
		 *  
		 * @param generator
		 * @param args
		 * @return 
		 * 
		 */
		public static function apply(generator:Class,params:Array=null):*
		{
			if (params) 
				return (applyFuns[params.length] as Function)(generator,params);
			else
				return new generator();
			
		}
		
		private static const applyFuns:Array = [apply0,apply1,apply2,apply3,apply4,apply5,apply6,apply7,apply8,apply9,apply10,apply11,apply12];
		private static function apply0(generator:Class,args:Array):*{return new generator()};
		private static function apply1(generator:Class,args:Array):*{return new generator(args[0])};
		private static function apply2(generator:Class,args:Array):*{return new generator(args[0],args[1])};
		private static function apply3(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2])};
		private static function apply4(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3])};
		private static function apply5(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3],args[4])};
		private static function apply6(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3],args[4],args[5])};
		private static function apply7(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3],args[4],args[5],args[6])};
		private static function apply8(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7])};
		private static function apply9(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8])};
		private static function apply10(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9])};
		private static function apply11(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10])};
		private static function apply12(generator:Class,args:Array):*{return new generator(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11])};
	}
}
