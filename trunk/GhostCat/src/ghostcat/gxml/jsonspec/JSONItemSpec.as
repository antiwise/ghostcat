package ghostcat.gxml.jsonspec
{
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.gxml.spec.ItemGroup;
	import ghostcat.util.ReflectUtil;
	
	/**
	 * 这个解析器在Spec的基础上增加了设置外部ID和自动监听事件的功能（事件都是弱引用）
	 * 初始化的时候需要将作为反射依据的对象写入构造函数
	 * 
	 * 提供替换类名的功能
	 * 
	 * {id:"skin",on_click:"clickHandler"}
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class JSONItemSpec extends JSONSpec
	{
		public function JSONItemSpec(root:*=null)
		{
			super(root);
		}
		
		/**
		 * 类名转换
		 */
		public var classNames:Object;
		
		/**
		 * 替换类名
		 * 
		 * @param xml
		 * 
		 */
		public function replaceClassName(obj:Object):void
		{
			if (classNames && obj.hasOwnProperty(classRefName) && obj[classRefName])
			{
				var name:String = obj[classRefName];
				for (var replacer:String in classNames)
				{
					if (replacer == name)
					{
						var o:* = classNames[replacer];
						if (o is Class)
							o = getQualifiedClassName(o);
						
						obj[classRefName] = o;
					}
				}
			}
		}
		
		/** @inheritDoc*/
		public override function createObject(source:*):*
		{
			if (!source)
				return null;
			
			replaceClassName(source);
			
			if (root)
			{
				var id:String;
				var handlers:Object = {};
				for (var p:String in source)
				{
					if (p == "id")
					{
						id = source[p];
						delete source[p];
					}
					else if (p.substr(0,3)=="on_")
					{
						handlers[p.substr(3)] = source[p];
						delete source[p];
					}
					
				}
			}
			
			var obj:* = super.createObject(source);
			
			if (root)
			{
				if (id)
					root[id] = obj;//如果设置了ID属性，创建的对象将会创建指定的外部引用
				
				if (obj is IEventDispatcher)
				{
					for (var key:String in handlers)
						(obj as IEventDispatcher).addEventListener(key,root[handlers[key]],false,0,true); 
				}
			}
			
			return obj;
		}
	}
}