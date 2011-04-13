package ghostcat.util.encrypt
{
	import ghostcat.util.text.Utf8;
	
	/*AES Counter-mode for Actionscript ported from AES Counter-mode implementation in JavaScript by Chris Veness
	- see http://csrc.nist.gov/public statications/nistpubs/800-38a/sp800-38a.pdf*/

	public class Base64 {
		
		private static const code : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		
		public static function encode(str : String, utf8encode : Boolean = false) : String {  
			// http://tools.ietf.org/html/rfc4648
			var o1 : int, o2 : int, o3 : int, bits : int, h1 : int, h2 : int, h3 : int, h4 : int, e : Array = [], pad : String = '', c : int, plain : String, coded : String;
			var b64 : String = Base64.code;
			
			plain = utf8encode ? Utf8.encode(str) : str;
			
			c = plain.length % 3;  // pad string to length of multiple of 3
			if (c > 0) { 
				while (c++ < 3) { 
					pad += '='; 
					plain += '\0'; 
				} 
			}
			
			// note: doing padding here saves us doing special-case packing for trailing 1 or 2 chars
			for (c = 0;c < plain.length;c += 3) {  
				// pack three octets into four hexets
				o1 = plain.charCodeAt(c);
				o2 = plain.charCodeAt(c + 1);
				o3 = plain.charCodeAt(c + 2);
				
				bits = o1 << 16 | o2 << 8 | o3;
				
				h1 = bits >> 18 & 0x3f;
				h2 = bits >> 12 & 0x3f;
				h3 = bits >> 6 & 0x3f;
				h4 = bits & 0x3f;
				
				// use hextets to index into code string
				e[c / 3] = b64.charAt(h1) + b64.charAt(h2) + b64.charAt(h3) + b64.charAt(h4);
			}
			coded = e.join('');
			
			coded = coded.slice(0, coded.length - pad.length) + pad;
			
			return coded;
		}
		
		public static function decode(str : String, utf8decode : Boolean = false) : String {
			var o1 : int, o2 : int, o3 : int, h1 : int, h2 : int, h3 : int, h4 : int, bits : int, d : Array = [], plain : String, coded : String;
			var b64 : String = Base64.code;
			
			coded = utf8decode ? Utf8.decode(str) : str; 
			
			for (var c : int = 0;c < coded.length;c += 4) {
				// unpack four hexets into three octets
				h1 = b64.indexOf(coded.charAt(c));
				h2 = b64.indexOf(coded.charAt(c + 1));
				h3 = b64.indexOf(coded.charAt(c + 2));
				h4 = b64.indexOf(coded.charAt(c + 3));
				
				bits = h1 << 18 | h2 << 12 | h3 << 6 | h4;
				
				o1 = bits >>> 16 & 0xff;
				o2 = bits >>> 8 & 0xff;
				o3 = bits & 0xff;
				
				d[c / 4] = String.fromCharCode(o1, o2, o3) + "";
				// check for padding
				if (h4 == 0x40) d[c / 4] = String.fromCharCode(o1, o2);
				if (h3 == 0x40) d[c / 4] = String.fromCharCode(o1);
			}
			plain = d.join('');
			
			return utf8decode ? Utf8.decode(plain) : plain; 
		}
	}
}