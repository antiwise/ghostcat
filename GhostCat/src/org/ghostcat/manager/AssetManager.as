package org.ghostcat.manager
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.ghostcat.core.Singleton;
	import org.ghostcat.text.TextUtil;

	/**
	 * 资源管理类
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class AssetManager extends Singleton
	{
		static public function get instance():AssetManager
		{
			return Singleton.getInstanceOrCreate(AssetManager) as AssetManager;
		}
		
		public var assetBase:String="";
		
		public var loadIcon:Class;
		
		public var errorIcon:Class;
		
		/**
		 * 通过类名来获得默认文件地址。地址始终是小写。
		 * 这个方法主要用于动态加载。可以同样利用jsfl将库中的类按类名分散到各个文件里，分散到目录的文件更容易管理，且不容易出现重名。
		 * 
		 * jsfl目录已经提供了这样一个jsfl脚本
		 * 
		 * @param ref	类名
		 * @param fileName	指定文件名
		 * @return 
		 * 
		 */		
		public function getDefaultFilePath(ref:String,fileName:String=null):String
		{
			var names:Array = ref.split("::");
			var url:String;
			if (names.length == 2)
			{
				if (fileName)
					names[1] = fileName;
				names[0] = (names[0] as String).replace(/\./g,"/");
				url = names.join("/").toLowerCase();
			}
			else
			{
				if (fileName)
					names[0] = fileName;
				url = (names[0] as String).toLowerCase();
			}
			return assetBase + url + ".swf";
		}
	}
}