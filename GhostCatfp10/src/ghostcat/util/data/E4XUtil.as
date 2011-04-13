package ghostcat.util.data
{
	import ghostcat.util.OperatorUtil;

	/**
	 * 用E4X的方式检索Object
	 * E4XUtil.exec([{code:5,info:100},{code:6,info:120},{code:7,info:140}],".(code >= 5 && code <= 6).info")	100,120
	 * E4XUtil.exec([[1,2],[2,3],[3,4],[4,5]],".([0] == 3).*[1]")	4
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class E4XUtil
	{
		static private function isValue(ch:String):Boolean
		{
			return ch != "[" && ch != ".";
		}
		
		static private function getPropertyInArray(obj:*,v:String,deepIn:Boolean):*
		{
			if (obj is Array)
			{
				var result:Array = [];
				for each (var child:* in obj)
				{
					var t:* = getPropertyInArray(child,v,deepIn);
					if (t)
					{
						if (deepIn && t is Array)
							result = result.concat(t);
						else
							result.push(t);
					}
				}
				return result;
			}
			else
			{
				return obj.hasOwnProperty(v) ? obj[v] : null;
			}
		}
		
		static public function exec(obj:*,exp:String):*
		{
			var pos:int = 0;
			
			var operNum:int;//括号数量
			var dotNum:int;//点符号数量
			var oldObj:*;//旧值
			
			var v:String;
			var ch2:String;
			var t:*;
			
			while (pos < exp.length) 
			{ 
				var ch:String = exp.charAt(pos);
				if (ch == ".")
				{
					dotNum = dotNum > 0 ? 2 : 1;
					pos++;
				}
				else if (ch == "[")
				{
					pos++;
					v = "";
					while (exp.charAt(pos) != "]" && operNum == 0 && pos < exp.length)
					{
						ch2 = exp.charAt(pos);
						if (ch2 == "[")
							operNum++;
						else if (ch2 == "]")
							operNum--;
						
						v += ch2;
						
						pos++;
					}
					pos++;
					
					oldObj = obj;
					obj = obj[OperatorUtil.exec(v)];
				}
				else if (ch == "*" && dotNum > 0)
				{
					var result:Array = [];
					for each (var child:* in obj)
					{
						if (child is Array)
							result = result.concat(child);
					}
					pos++;
					
					oldObj = obj;
					obj = result;
				}
				else if (ch == "(" && dotNum > 0)
				{
					pos++;
					v = "";
					while (exp.charAt(pos) != ")" && operNum == 0 && pos < exp.length)
					{
						ch2 = exp.charAt(pos);
						if (ch2 == "(")
							operNum++;
						else if (ch2 == ")")
							operNum--;
						
						v += ch2;
						
						pos++;
					}
					pos++;
					
					result = [];
					for each (child in obj)
					{
						if (child is Array)
						{
							t = {};
							for (var i:int = 0;i < child.length;i++)
							{
								t["["+i+"]"] = child[i];
							}
						}
						else
						{
							t = child;
						}
					
						if (OperatorUtil.exec(v,t))
						{
							result.push(child);
						}
					}
					
					oldObj = obj;
					obj = result;
					dotNum = 0;
				}
				else if (dotNum > 0)
				{
					v = "";
					while (isValue(exp.charAt(pos)) && pos < exp.length)
					{
						v += exp.charAt(pos);
						pos++;
					}
					
					if (v == "childIndex()")
					{
						t = oldObj;
						oldObj = obj;
						
						while (obj is Array)
							obj = obj[0];
						
						obj = t.indexOf(obj);
					}
					else if (v == "parent()")
					{
						t = oldObj;
						oldObj = obj;
						obj = t;
					}
					else if (v == "length()")
					{
						oldObj = obj;
						obj = obj.length;
					}
					else
					{
						oldObj = obj;
						obj = getPropertyInArray(obj,v,dotNum >= 2);
					}
					
					dotNum = 0;
				}
			}
			return obj;
		}
	}
}