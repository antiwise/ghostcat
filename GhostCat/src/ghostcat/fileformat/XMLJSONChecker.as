package ghostcat.fileformat
{
	import flash.utils.IDataInput;

	public final class XMLJSONChecker
	{
		/**
		 * 判断数据格式是否是XML或者JSON 
		 * @param bytes
		 * @return 
		 * 
		 */
		static public function check(bytes:IDataInput):String
		{
			try
			{
				var v:String = bytes.readUTFBytes(1);
			}
			catch (e:Error){};
			if (v && v.charCodeAt(0) == 65279)//UTF-8文件头
			{
				try
				{
					v = bytes.readUTFBytes(1);//再次读取
				}
				catch (e:Error){};
			}
			
			if (v == "<")
				return "xml";
			else if (v == "{" || v == "[" || v == "\"")
				return "json";
			else
				return null;
		}
	}
}