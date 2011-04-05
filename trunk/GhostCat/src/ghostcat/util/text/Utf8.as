package ghostcat.util.text
{
	/**
	 * UTF8转换
	 * 
	 */
	public class Utf8
	{
		public static function encode(text : String) : String
		{
			var result : String = "";
			
			for (var n : int = 0;n < text.length;n++)
			{
				var c : int = text.charCodeAt(n);
				if (c < 128)
				{
					result += String.fromCharCode(c);
				}
				else if (c > 127 && c < 2048)
				{
					result += String.fromCharCode((c >> 6) | 192);
					result += String.fromCharCode((c & 63) | 128);
				}
				else
				{
					result += String.fromCharCode((c >> 12) | 224);
					result += String.fromCharCode(((c >> 6) & 63) | 128);
					result += String.fromCharCode((c & 63) | 128);
				}
			}
			
			return result;
		}
		
		public static function decode(text : String) : String
		{
			var result : String = "";
			var i : int = 0;
			var c1 : int = 0;
			var c2 : int = 0;
			var c3 : int = 0;
			
			while (i < text.length)
			{
				c1 = text.charCodeAt(i);
				if (c1 < 128)
				{
					result += String.fromCharCode(c1);
					i++;
				}
				else if (c1 > 191 && c1 < 224) 
				{
					c2 = text.charCodeAt(i + 1);
					result += String.fromCharCode(((c1 & 31) << 6) | (c2 & 63));
					i += 2;
				}
				else
				{
					c2 = text.charCodeAt(i + 1);
					c3 = text.charCodeAt(i + 2);
					result += String.fromCharCode(((c1 & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
					i += 3;
				}
			}
			
			return result;
		}
	}
}