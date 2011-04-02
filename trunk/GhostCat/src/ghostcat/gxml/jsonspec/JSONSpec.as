package ghostcat.gxml.jsonspec
{
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.ReflectXMLUtil;
	import ghostcat.util.Util;
	import ghostcat.util.core.ClassFactory;
	
	import mx.events.CalendarLayoutChangeEvent;

	/**
	 * JSON对象转换为封闭类的转换器
	 * @author flashyiyi
	 * 
	 */
	public class JSONSpec implements IJSONSpec
	{
		/**
		 * 类名转换属性
		 */
		public var classRefName:String = "classRef";
		
		/**
		 * 构造函数参数 
		 */
		public var paramsName:String = "params";
		
		private var _root:*;
		
		public function JSONSpec(root:*=null):void
		{
			this.root = root;
		}
		
		/**
		 * 基础对象，用于反射外部属性
		 */
		public function get root():*
		{
			return _root;
		}
		
		public function set root(v:*):void
		{
			_root = v;
		}
		
		/**
		 * 创建对象以及值
		 * 
		 * @param source	数据源
		 * 
		 */
		public function createObject(obj:*):*
		{
			if (obj is Array)
			{
				var arr:Array = [];
				for (var i:int = 0; i < obj.length;i++)
				{
					var item:* = obj[i];
					var v:* = createObject(item);
					applyProperties(arr,v,obj);
					addChild(arr,v,i);
				}
				return arr;
			}
			else if (obj && obj["constructor"] == Object)
			{
				var name:String = getName(obj);
				if (name)
					var ref:Class = getDefinitionByName(name) as Class;
					
				if (!ref)
					ref = Object;
					
				var params:Array = getConstructorParams(obj);//获得构造函数参数
				var target:* = ClassFactory.apply(ref,params);
				this.createChildren(target,obj);
				return target;
			}
			else
			{
				return obj;
			}
		}
		
		/**
		 * 获得构造函数参数
		 * @return 
		 * 
		 */
		protected function getConstructorParams(source:*):Array
		{
			var obj:Array = source[paramsName];
			delete source[paramsName];
			return obj;
		}
		
		/**
		 * 附加子对象
		 * 
		 * @param source 父对象
		 * @param child	子对象
		 * 
		 */
		public function addChild(source:*,child:*,name:*):void
		{
			source[name] = child;
		}
		
		/**
		 * 给子对象赋初值
		 * 
		 * @param source 父对象
		 * @param child	子对象
		 * @param obj	父对象数据
		 * 
		 */
		public function applyProperties(source:*,child:*,obj:*):void
		{
			//需要从父对象传值给子对象可重写此方法
		}
		
		/**
		 * 创建全部子对象
		 * 
		 * @param source	父对象
		 * @param obj	数据	
		 */
		protected function createChildren(source:*,obj:*):void
		{
			for (var p:String in obj)
			{
				var item:* = obj[p];
				var v:* = createObject(item);
				applyProperties(source,v,obj);
				addChild(source,v,p);
			}
		}
		
		/**
		 * 判断是否是Object
		 * 
		 * @param xml
		 * @return 
		 * 
		 */
		protected function isObject(obj:Object):Boolean
		{
			return obj != null && !(obj is Number || obj is String || obj is Array || obj is Boolean);
		}
		
		protected function getName(obj:Object):*
		{
			var name:String;
			if (classRefName && obj.hasOwnProperty(classRefName))
			{
				name = obj[classRefName];
				delete obj[classRefName];
				return name;
			}
			else
			{
				return null;
			}
		}
	}
}