package org.ghostcat.ui
{
	import flash.display.DisplayObject;
	
	import org.ghostcat.util.ClassFactory;
	import org.ghostcat.util.SearchUtil;

	/**
	 * 帮助快速创建界面的辅助类
	 * 
	 * @author Administrator
	 * 
	 */
	public final class UIBuilder
	{
		static public function build(target:DisplayObject,skin:DisplayObject,params:Object):void
		{
			for (var key:String in params)
			{
				var ref:ClassFactory;
				if (params[key] is Class)
					ref = new ClassFactory(params[key] as Class);
				else
					ref = params[key] as ClassFactory;
				
				var s:DisplayObject = SearchUtil.findChildByProperty(skin,"name",key);
				ref.params = [s];
				
				target[key] = ref.newInstance();
			}
		}
		
	}
}