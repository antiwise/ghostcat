package ghostcat.util.code
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 数据对象代码生成器
	 * @author flashyiyi
	 * 
	 */
	public final class VOCreater
	{
		public static function createByObject(v:Object,classPath:String):String
		{
			var index:int;
			var result:String = "";
			var importDict:Object = {};
			for (var p:String in v)
			{
				var className:QName = CodeCreater.getClassName(v[p]);
				importDict[(className.uri ? className.uri + ".": "") + className.localName] = null;
				result += "public var " + p + ":" + className.localName + ";";
			}
			result += "public function " + CodeCreater.getClassName(classPath).localName + "(v:Object){setData(v)}";
			result += "public function setData(v:Object):void{if (v){"
			for (p in v)
			{
				result += "this." + p + " = " + "v." + p + ";";
			}
			result += "}}";
			
			result = CodeCreater.pack(classPath,result,importDict);
			return CodeCreater.format(result);
		}
	}
}