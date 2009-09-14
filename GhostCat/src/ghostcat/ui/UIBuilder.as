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
	 * @author Administrator
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
		static public function build(target:GBase,params:Object=null,limitIn:Boolean=false):void
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