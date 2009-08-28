package org.ghostcat.gxml
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import org.ghostcat.util.Singleton;
	import org.ghostcat.gxml.spec.ItemSpec;

	/**
	 * XML解析类
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