package ghostcat.ui
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	import ghostcat.util.ClassFactory;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.SearchUtil;

	/**
	 * 帮助快速创建界面的辅助类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class UIBuilder
	{
		/**
		 * 自动构建UI组件。会根据target的公开属性来自动查询Skin内的同名元件并转换。
		 * 
		 * @param target	目标
		 * @param params	规定需要转换的对象的实际类型，键为属性名，值为属性类型（可以使用ClassFactory），将值设为空则不做任何限制。
		 * @param limitIn	是否限制只转换parms属性规定的对象
		 */
		static public function buildAll(target:GBase,params:Object=null,limitIn:Boolean=false):void
		{
			var skin:DisplayObject = target.content;
			var children:Array = SearchUtil.findChildrenByClass(skin,DisplayObject);
			var property:Object = ReflectUtil.getPropertyTypeList(skin,true);
			
			for (var i:int = 0;i < children.length;i++)
			{
				var obj:DisplayObject = children[i] as DisplayObject;
				var name:String = obj.name;
				if (property[name])
				{
					var ref:ClassFactory;
					if (params)
					{
						if (params[name])
						{
							if (params[name] is Class)
								ref = new ClassFactory(params[name] as Class);
							else if (params[name] is ClassFactory)
								ref = params[name] as ClassFactory;
						}
						else if (!limitIn)
							ref = new ClassFactory(property[name] as Class);
					}
					else
						ref = new ClassFactory(property[name] as Class)
					
					
					if (ref)
					{
						if (ref.params)
							ref.params[0] = obj;	
						else
							ref.params = [obj];
						
						target[name] = ref.newInstance();
					}
				}
			}
		}
		
		/**
		 * 单独构建一个UI组件
		 *  
		 * @param target	目标
		 * @param name	名称
		 * @param param	重定义参数，如果是ClassFactory则是重定义类型，如果是Object则设定初始值，如果是Array则设定构造方法参数
		 * 这些参数有关Skin的部分将会被忽略，而以找到的Skin为准
		 * 
		 */
		public static function build(target:GBase, name:String, param:*=null):DisplayObject
		{
			var skin:DisplayObject = SearchUtil.findChildByProperty(target.content,"name",name);
			var cls:ClassFactory = new ClassFactory(ReflectUtil.getTypeByProperty(target,name));
				
			if (param is Class)
				cls = new ClassFactory(param as Class);
			else if (param is ClassFactory)
				cls = param as ClassFactory;
			else if (param is Array)
				cls.params = (param as Array).concat();
			else if (param)
				cls.properties = param;
			
			if (skin)
			{
				if (cls.params)
					cls.params[0] = skin;
				else 
					cls.params = [skin];
			}
			
			return cls.newInstance(); 
		}
		
		/**
		 * 根据名字获取Skin
		 *  
		 * @param skin
		 * @param name
		 * @return 
		 * 
		 */
		public static function getSkinByName(skin:DisplayObject,name:String):DisplayObject
		{
			return SearchUtil.findChildByProperty(skin,"name",name);
		}
		
	}
}