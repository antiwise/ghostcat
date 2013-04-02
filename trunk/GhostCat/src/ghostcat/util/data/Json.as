package ghostcat.util.data {
	public class Json {
		private static var decoder:JsonDecoder=null;
		private static var encoder:JsonEncoder=null;
		
		public static function decode(str:String):* {
			if (decoder==null)decoder=new JsonDecoder();
			return decoder.decode(str);
		}
		
		public static function encode(obj:*):String {
			if (encoder==null)encoder=new JsonEncoder();
			return encoder.encode(obj);
		}
	}
}
class JsonDecoder {
	private var chr:int;
	private var tok:int;
	private var src:String;
	private var lastPos:int;
	private var nextPos:int;
	private var cachedChr:Boolean;
	private var cachedTok:Boolean;
	
	public function decode(str:String):* {
		var val:*;
		src=str;
		nextPos=0;
		cachedChr=false;
		cachedTok=false;
		val=nextValue();
		if (nextToken()!=0xff)error("More than one value");
		return val;
	}
	
	private function nextChar():int {
		if(cachedChr){
			cachedChr=false;
			return chr;
		}
		return chr=src.charCodeAt(nextPos++)||0;
	}
	
	private function nextToken():int {
		if(cachedTok){
			cachedTok=false;
			return tok;
		}
		while(nextChar()==0x20||chr==0x09||isNewline(chr)){};
		if(chr==0x2f){
			if(nextChar()==0x2f){
				while(!isNewline(nextChar())){
					if(chr==0x00)return tok=0xff;
				}
			}
			else if(chr==0x2a){
				while(true){
					if(nextChar()==0x2a){
						if(nextChar()==0x2f)break;
						else if(chr==0x2a)cachedChr=true;
					}
					if(chr==0x00)error("Find /* but cannot find */");
				}
			}
			else error("Unkown token /"+String.fromCharCode(chr));
			return nextToken();
		}
		lastPos=nextPos-1;
		if(chr==0x22||chr==0x27)return tok=0xfc;
		if(chr==0x5d)return tok=0xfb;
		if(chr==0x5b)return tok=0xfa;
		if(chr==0x7d)return tok=0xf9;
		if(chr==0x7b)return tok=0xf8;
		if(chr==0x2c)return tok=0xf6;
		if(chr==0x3a)return tok=0xf7;
		if(chr==0x2d)return tok=0xf5;
		if(chr==0x00)return tok=0xff;
		if(chr==0x2e){
			if(!isDigit(nextChar()))error("Need digit after .");
			return nextFraction();
		}
		if(isDigit(chr)){
			if(chr==0x30){
				if(nextChar()!=0x78)cachedChr=true;
				else{
					if(!isHex(nextChar()))error("Need hexadecimal digit after 0x");
					while(isHex(nextChar())){};
					return cache(0xfe);
				}
			}
			while(true){
				if(nextChar()==0x2e)return nextFraction();
				if(chr==0x65||chr==0x45)return nextExponent();
				if(!isDigit(chr))break;
			}
			return cache(0xfe);
		}
		
		if(!isIdentifier(chr))error("Unkown token "+flush());
		while(isIdentifier(nextChar())){};
		return cache(0xfd);
	}
	
	private function nextValue():* {
		if(nextToken()==0xfd){
			var str:String=flush(1);
			if(str=="NaN")return NaN;
			if(str=="null")return null;
			if(str=="true")return true;
			if(str=="false")return false;
			if(str=="Infinity")return Infinity;
			if(str=="undefined")return undefined;
			error("Unkown idenfifier "+str);
		}
		if(tok==0xf8){
			var obj:Object={};
			if(nextToken()!=0xf9){
				cachedTok=true;
				while (true){
					var key:String;
					if (nextToken()==0xfc)key=nextString();
					else if (tok!=0xfd)error("Unexpected token "+flush());
					if (nextToken()!=0xf7)error("Expected token : found "+flush());
					obj[key]=nextValue();
					if (nextToken()==0xf9)break;
					if (tok!=0xf6)error("Expected token } or , found "+flush());
				}
			}
			return obj;
		}
		if(tok==0xfa){
			var arr:Array=[];
			if(nextToken()!=0xfb){
				var needComma:Boolean=false;
				var index:int=0;
				cachedTok=true;
				while(true){
					if(nextToken()==0xfb)break;
					if(tok==0xf6){
						arr.length=++index;
						needComma=false;
					}
					else if(needComma)error("Expected token  ] or , found "+flush());
					else{
						needComma=true;
						cachedTok=true;
						arr[index]=nextValue();
					}
				}
			}
			return arr;
		}
		if(tok==0xfc)return nextString();
		if(tok==0xfe)return Number(flush(1));
		if(tok==0xff)error("End of input was encountered");
		if(tok!=0xf5)error("Unexpected token "+flush());
		return -nextValue();
	}
	
	private function nextString():String {
		lastPos=nextPos;
		var str:String="";
		var tag:int=chr;
		while(nextChar()!=tag){
			if(chr==0x00||isNewline(chr))error("Unclosed string");
			if(chr==0x5c){
				str+=flush(1);
				lastPos+=2;
				if(nextChar()==0x75||chr==0x78){
					var n:int=chr==0x75?4:2;
					while(n>0&&isHex(nextChar()))n--;
					if(n==0)str+=String.fromCharCode(parseInt(flush(),16));
					else nextPos=--lastPos;
				}
				else if(chr==0x6e)str+="\n";
				else if(chr==0x72)str+="\r";
				else if(chr==0x62)str+="\b";
				else if(chr==0x66)str+="\f";
				else if(chr==0x74)str+="\t";
				else lastPos--;
			}
		}
		return str+flush(1);
	}
	
	private function nextFraction():int {
		while(true){
			if(nextChar()==0x65||chr==0x45)return nextExponent();
			if(!isDigit(chr))break;
		}
		return cache(0xfe);
	}
	
	private function nextExponent():int {
		if(nextChar()!=0x2b&&chr!=0x2d)cachedChr=true;
		if(!isDigit(nextChar()))error("Need digit after exponent");
		while (isDigit(nextChar())){};
		return cache(0xfe);
	}
	
	private function cache(token:int):int {
		cachedChr=true;
		return tok=token;
	}
	
	private function flush(back:int=0):String {
		return src.substring(lastPos,lastPos=nextPos-back);
	}
	
	private function error(text:String):void {
		throw new Error(text);
	}
	
	private function isHex(c:int):Boolean {
		return isDigit(c)||(c>0x60&&c<0x67)||(c>0x40&&c<0x47);
	}
	
	private function isDigit(c:int):Boolean {
		return c>0x2f&&c<0x3a;
	}
	
	private function isNewline(c:int):Boolean {
		return c==0x0a||c==0x0d;
	}
	
	private function isIdentifier(c:int):Boolean {
		if(isDigit(c))return true;
		if(c>0x60&&c<0x7b)return true;
		if(c>0x40&&c<0x5b)return true;
		if(c==0x5f||c==0x24)return true;
		if(c==0xd7||c==0xf7)return false;
		if(c<0x00c0||c>0xfaff)return false;
		if(c>0x00d6&&c<0x00d8)return false;
		if(c>0x00f6&&c<0x00f8)return false;
		if(c>0x1fff&&c<0x3040)return false;
		if(c>0x318f&&c<0x3300)return false;
		if(c>0x337f&&c<0x3400)return false;
		if(c>0x3d2d&&c<0x4e00)return false;
		if(c>0x9fff&&c<0xf900)return false;
		return true;
	}
}
class JsonEncoder {
	private var unescapes:Object={"\b":"b","\f":"f","\n":"n","\r":"r","\t":"t"};
	private var escapePtn:RegExp=/["\b\f\n\r\t\\]/g;//"
	private var controlPtn:RegExp=/\x00-\x19/g;
	
	public function encode(obj:*):String {
		var str:String=null;
		var bool:Boolean=false;
		if(obj===null)return "null";
		if(obj===undefined)return "undefined";
		if(obj is String)return encodeString(obj);
		if(obj is Array){
			str="[";
			for (var i:int=0,j:int=obj["length"];i<j;i++){
				bool?(str+=","):(bool=true);
				str+=encode(obj[i]);
			}
			return str+"]";
		}
		if(obj["constructor"]==Object){
			str="{";
			for (var k:String in obj){
				bool?(str+=","):(bool=true);
				str+=encodeString(k)+":"+encode(obj[k]);
			}
			return str+"}";
		}
		return obj;
	}
	
	private function escapeRepl(...args):String {
		return "\\"+(unescapes[args[0]]||args[0]);
	}
	
	private function controlRepl(...args):String {
		var hexCode:String=String(args[0]).charCodeAt(0).toString(16);
		if (hexCode.length==1)hexCode="0"+hexCode;
		return "\\x"+hexCode;
	}
	
	private function encodeString(str:String):String {
		str=str.replace(escapePtn,escapeRepl);
		str=str.replace(controlPtn,controlRepl);
		return "\""+str+"\"";
	}
}
