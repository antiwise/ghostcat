package ghostcat.fileformat.csv
{
	public final class CSVDecoder
	{
		public static function decode():Array
		{
			
			var v:String = '"12321321321"",31\r12312,3123213123123""","""123adfda",asdas"df,123,123\r\n123,,123,123,123\r\n';
			v = v.replace(/\r\n/g,"\n");
			
			var result:Array = [];
			var line:Array = [];
			result.push(line);
			
			var index:int = 0;
			var nextIndex:int;
			while (index < v.length)
			{
				var reg:RegExp;
				var s:String;
				if (v.charAt(index) == '"')
				{
					index++;
					
					reg = /\"(,|\n)/;
					reg.lastIndex = index + 1;
					nextIndex = v.search(reg);
					if (nextIndex == -1)
						nextIndex = v.length;
					
					s = v.slice(index,nextIndex);
					s = s.replace(/""/g,'"');
					
					nextIndex++;
				}
				else
				{
					reg = /,|\n/;
					reg.lastIndex = index + 1;
					nextIndex = v.search(reg);
					if (nextIndex == -1)
						nextIndex = v.length;
					
					s = v.slice(index,nextIndex);
				}
				
				line.push(s);
				if (nextIndex < v.length && v.charAt(nextIndex) == "\n")
				{
					line = [];
					result.push(line);
				}
				index = nextIndex + 1;
			}
			return result;
		}
	}
}