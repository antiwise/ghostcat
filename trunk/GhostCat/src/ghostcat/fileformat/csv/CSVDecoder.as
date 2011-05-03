package ghostcat.fileformat.csv
{
	public final class CSVDecoder
	{
		public static function decode():Array
		{
			
			var text:String = '"12321321321"",31\r12312,3123213123123""","""123adfda",asdas"df,123,123\r\n123,,123,123,123\r\n';
			if (text == null)
				return null;
			
			var result:Array = [];
			var line:Array = [];
			var field:String = "";
			var isInQuotation:Boolean = false;//字符串模式
			var isInField:Boolean = true;//是否在读取Field，用来表示空Field
			var i:int = 0;
			while (i < text.length)
			{
				var ch:String = text.charAt(i);
				if (isInQuotation)
				{
					if (ch == '"')
					{
						if (i < text.length - 1 && text.charAt(i + 1) == '"')//重复"只算一个，切不结束字符串模式
						{
							field += '"';
							i++;
						}
						else
						{
							isInQuotation = false;
						}
					}
					else
					{
						field += ch;//字符串模式中所有字符都要加入
					}
				}
				else
				{
					switch (ch)
					{
						case ',':
							line.push(field);
							field = "";
							isInField = true;
							break;
						case '"':
							if (isInField)
								isInQuotation = true;//进入字符串模式
							else
								field += ch;
							break;
						case '\r':
							if (field.length > 0 || isInField)
							{
								line.push(field);
								field = "";
							}
							result.push(line);
							line = [];
							isInField = true;//下一行首先应该是数据
							if (i < text.length - 1 && text.charAt(i + 1) == '\n')//跳过\r\n
								i++;
							break;
						default:
							isInField = false;
							field += ch;
							break;
					}
				}
				i++;
			}
			//收尾工作
			if (field.length > 0 || isInField && line.length > 0)//如果是isInField标记的单元格，则要保证这行有其他数据，否则单独一个空单元格的行是没有意义的
				line.push(field);
			
			if (line.length > 0)
				result.push(line);
			
			return result;
		}
	}
}