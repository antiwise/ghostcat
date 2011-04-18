package ghostcat.util.code
{
	/**
	 * 数据对象代码生成器
	 * @author flashyiyi
	 * 
	 */
	public final class VOCreater
	{
		public static function createByObject(v:Object,className:String):String
		{
			var result:String = "";
			var pack:String;
			var name:String;
			var index:int = className.lastIndexOf(".");
			if (index == -1)
			{
				pack = "";
				name = className;
			}
			else
			{
				pack = className.slice(0,index);
				name = className.slice(index + 1);
			}
			
			result += "package " + pack + "\n";
			result += "{" + "\n";
			result += "\tpublic class " + name + "\n";
			result += "\t{" + "\n";
			for (var p:String in v)
			{
			}
			result += "\t{" + "\n";
			result += "}" + "\n";
			return result;
		}
	}
}