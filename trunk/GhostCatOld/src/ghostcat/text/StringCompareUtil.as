package ghostcat.text
{
	/**
	 * 兼容性保留
	 */	
	public final class StringCompareUtil
	{
		public static function compare(s1:String,s2:String):Array   
		{   
			var actions:Array = [];//全部操作  
			var prev:Array;//上一个操作
			var i1:int = 0;
			var i2:int = 0;	    
			while(i2 < s2.length)   
			{   
				var status:int = s1.indexOf(s2.charAt(i2),i1);
				if (status >= 0)
					status -= i1;
				
				if(status == 0)
				{   
					i1++;   
					i2++;   
				}   
				else
				{
					if(status == -1)   
					{   
						if (prev && prev[0]==false && prev[1] == i1)
							prev[2] += s2.charAt(i2);
						else
						{
							prev = [false,i1,s2.charAt(i2)];
							actions.push(prev);
						}
						
						i2++;
					}   
					else   
					{   
						if (prev && prev[0]==true && prev[1] + prev[2].length == i1)
							prev[2] += s1.charAt(i1);
						else
						{
							prev = [true,i1,s1.charAt(i1)];
							actions.push(prev);
						}
						
						i1++;   
					}  
				}
			}
			
			if (i1 < s1.length)
				actions.push([true,i1,s1.substr(i1)]);
			
			return actions;
		}
		
		/**
		 * 将变化数组应用到当前字符串上
		 * 
		 * @param s
		 * @param actions
		 * 
		 */
		public static function apply(s:String,actions:Array):String
		{
			var offest:int = 0;
			for (var i:int = 0;i < actions.length;i++)
			{
				var action:Array = actions[i];
				if (action[0])
				{
					s = s.substr(0,action[1] + offest) + s.substr(action[1] + action[2].length + offest);
					offest -= action[2].length;
				}
				else
				{
					s = s.substr(0,action[1] + offest) + action[2] + s.substr(action[1] + offest);
					offest += action[2].length;
				}
			}
			return s;
		}
	}
}