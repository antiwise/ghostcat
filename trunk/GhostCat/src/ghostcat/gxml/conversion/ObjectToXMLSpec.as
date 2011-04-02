package ghostcat.gxml.conversion
{
	import flash.media.Sound;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.gxml.jsonspec.IJSONSpec;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.ReflectXMLUtil;

	/**
	 * 对象转换为XML的转换器（可以兼容封闭对象）
	 * @author flashyiyi
	 * 
	 */
	public class ObjectToXMLSpec implements IJSONSpec
	{
		/**
		 * 表示XML名称的属性
		 */
		public var classRefName:String = "classRef";
		
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
				var source:XMLList = new XMLList();
				for (var i:int = 0; i < obj.length;i++)
				{
					var item:* = obj[i];
					var v:* = createObject(item);
					applyProperties(source,v,obj);
					addChild(source,v,i);
				}
				return source;
			}
			else if (isObject(obj))//是类
			{
				var xml:XML = <xml/>;
				xml.setName(getName(obj));
				createChildren(xml,obj);//创建类的子对象
				return xml;
			}
			else if (obj != null)//是属性
			{
				xml = <xml/>;
				xml.setName(getName(obj));
				xml.appendChild(obj);
				return xml;
			}
			else
			{
				return null;
			}
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
			if (source is XMLList)
			{
				XMLList(source)[name] = child;
			}
			else if (source is XML)
			{	
				var xml:XML = <xml/>;
				xml.setName(name)
				xml.appendChild(child);
				
				XML(source).appendChild(xml);
			}
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
			if (obj["constructor"] != Object)
				obj = ReflectUtil.getPropertyList(obj);
			
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
				return ReflectUtil.getQName(obj);
			}
		}
		
		public function get root():*
		{
			return null;
		}
		
		public function set root(v:*):void
		{
			
		}
	}
}