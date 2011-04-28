package ghostcat.util.text
{
	public final class TextTransferUtil
	{
		static public function XMLEncode(str:String):String
		{
			var xml:XML = <xml/>
			xml.appendChild(str);
			var str:String = xml.toXMLString();
			str = str.replace(/\r/gi,"&#xd;");
			str = str.replace(/\n/gi,"&#xa;");
			return str.slice(5,str.length - 6);
		}
		
		static public function XMLDecode(str:String):String
		{
			try
			{
				var xml:XML =  new XML("<xml>" + str + "</xml>")
				return xml.toString();
			}catch (e:Error){};
			return null;
		}
		
		static public function stringEncode(str:String):String
		{
			return str.replace(/\"|\\/g,"\\$&");
		}
		
		static public function stringDecode(str:String):String
		{
			return str.replace(/\\(.)/g,"$1");
		}
	}
}