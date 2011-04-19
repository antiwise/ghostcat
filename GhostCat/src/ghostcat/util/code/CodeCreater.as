package ghostcat.util.code
{
	import flash.utils.getQualifiedClassName;

	public final class CodeCreater
	{
		static public function format(str:String):String
		{
			var p:int = 0;
			var i:int;
			var result:String = "";
			var tab:int = 0;
			var prev:String = "";
			var ch:String = "";
			while (p < str.length)
			{
				prev = ch;
				ch = str.charAt(p);
				if (ch == "{")
				{
					result += "\n"
					for (i = 0;i < tab;i++)
						result += "\t";
					result += ch + "\n";
					tab++;
					for (i = 0;i < tab;i++)
						result += "\t";
				}
				else if (ch == "}")
				{
					tab--;
					result += "\n"
					for (i = 0;i < tab;i++)
						result += "\t";
					result +=  ch + "\n";
					for (i = 0;i < tab;i++)
						result += "\t";
				}
				else if (prev == ";")
				{
					result += "\n";
					for (i = 0;i < tab;i++)
						result += "\t";
					result += ch;
				}
				else
				{
					result += ch;
				}
				p++;
			}
			return result;
		}
		
		static public function pack(classPath:String,body:String = "",importObj:Object = null):String
		{
			var pack:String;
			var name:String;
			
			var index:int = classPath.lastIndexOf(".");
			if (index == -1)
			{
				pack = "";
				name = classPath;
			}
			else
			{
				pack = classPath.slice(0,index);
				name = classPath.slice(index + 1);
			}
			
			var imports:String = "";
			for (var p:String in importObj)
			{
				imports += "import " + p + ";"
			}
			
			body = "public class " + name + "{" + body + "}";
			body = "package " + pack + "{" + imports + body + "}";
			
			return body;
		}
		
		static public function getClassName(obj:*):QName
		{
			if (!(obj is String))
				obj = getQualifiedClassName(obj);
			
			var names:Array = obj.split("::");
			if (names.length == 2)
				return new QName(names[0],names[1]);
			else
				return new QName(null,names[0]);
			
			return null;
		}
	}
}