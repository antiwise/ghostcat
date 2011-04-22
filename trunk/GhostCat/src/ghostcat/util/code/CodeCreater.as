package ghostcat.util.code
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.util.display.SearchUtil;

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
		
		static private function getClassName(obj:*):QName
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
		
		public static function createByObject(v:Object,classPath:String):String
		{
			var index:int;
			var result:String = "";
			var importDict:Object = {};
			for (var p:String in v)
			{
				var className:QName = CodeCreater.getClassName(v[p]);
				if (className.uri)
					importDict[className.uri + "." + className.localName] = null;
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
		
		public static function createBySkin(v:DisplayObject,classPath:String,skinName:String = "content"):String
		{
			var vars:String = "";
			var creates:String = "";
			var objs:Array = SearchUtil.findChildrenByClass(v,InteractiveObject);
			var importDict:Object = {"flash.display.Sprite":null};
			
			for each (var child:InteractiveObject in objs)
			{
				if (child.name && child.name.slice(0,8) != "instance")
				{
					var className:QName = CodeCreater.getClassName(child);
					if (className.uri)
						importDict[className.uri + "." + className.localName] = null;
					vars += "public var " + child.name + ":" + className.localName + ";"
					creates += "this." + child.name + " = " + skinName;
					var path:String = "[\"" + child.name + "\"]";
					while (child.parent != v)
					{
						child = child.parent;
						path = "[\"" + child.name + "\"]" + path;
					}
					creates += path + " as " + className.localName + ";";
				}
			}
			var result:String = CodeCreater.pack(classPath,vars + "public function " + CodeCreater.getClassName(classPath) + "("+ skinName + ":Sprite){" + creates + "}",importDict);
			return CodeCreater.format(result);
		}
	}
}