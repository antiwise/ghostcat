package org.ghostcat.gxml
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import org.ghostcat.core.Singleton;
	import org.ghostcat.gxml.spec.ItemSpec;

	/**
	 * GXML除了没有绑定，样式，效果，以及标签内代码，其他部分几乎和MXML一模一样。具体用法请参考FLEX。
	 * 此外，你还可以使用register方法重定义特定标签的处理方式，也就是说，愿意的话也可以实现自己的绑定，样式，效果，
	 * 以及各种额外功能，诸如自动继承父类属性。
	 * 
	 * GXML从设计上并不希望只被用作显示对象，事实上稍加修改，实现ISpec，就可以将它改造成一个脚本引擎
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GXMLManager extends Singleton
	{
		static public function get instance():GXMLManager
		{
			return Singleton.getInstanceOrCreate(GXMLManager) as GXMLManager;
		}
		
		private var specs:Dictionary;
		
		private var defaultSpec:Class;
		
		public function GXMLManager()
		{
			specs = new Dictionary();
			registerDefault(ItemSpec);
		}
		
		public function registerDefault(spec:Class):void
		{
			defaultSpec = spec;
		}
		
		public function register(type:*,spec:Class):void
		{
			specs[type] = spec;
		}
	}
}