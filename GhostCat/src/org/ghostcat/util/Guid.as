package org.ghostcat.util
{
	import flash.system.Capabilities;
	
	/**
	 * 生成一个GUID（由于无法获得网卡号，以serverString代替，实际上不能保证时空上唯一）
	 * 
	 */
	public class Guid
	{
		private static var counter:Number=0;
		
		public var value:Array;
		
		public function Guid()
		{
			var id1:Number=new Date().getTime();
			var id2:Number=Math.random() * Number.MAX_VALUE;
			var id3:String=flash.system.Capabilities.serverString;
			var id:String = id1 + id3 + id2 + (counter++);
			this.value = core_sha1(str2binb(id), id.length * 8);
		}
		
		private function core_sha1(x:Array, len:Number):Array
		{
			x[len >> 5]|=0x80 << (24 - len % 32);
			x[((len + 64 >> 9) << 4) + 15]=len;
			var w:Array=new Array(80), a:Number=1732584193;
			var b:Number=-271733879, c:Number=-1732584194;
			var d:Number=271733878, e:Number=-1009589776;
			for (var i:int=0; i < x.length; i+=16)
			{
				var olda:Number=a, oldb:Number=b;
				var oldc:Number=c, oldd:Number=d, olde:Number=e;
				for (var j:int=0; j < 80; j++)
				{
					if (j < 16)
						w[j]=x[i + j];
					else
						w[j]=rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
					
					var t:Number=safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)), safe_add(safe_add(e, w[j]), sha1_kt(j)));
					e=d;
					d=c;
					c=rol(b, 30);
					b=a;
					a=t;
				}
				a=safe_add(a, olda);
				b=safe_add(b, oldb);
				c=safe_add(c, oldc);
				d=safe_add(d, oldd);
				e=safe_add(e, olde);
			}
			return new Array(a, b, c, d, e);
		}
		
		private function sha1_ft(t:Number, b:Number, c:Number, d:Number):Number
		{
			if (t < 20)
				return (b & c) | ((~b) & d);
			if (t < 40)
				return b ^ c ^ d;
			if (t < 60)
				return (b & c) | (b & d) | (c & d);
			return b ^ c ^ d;
		}
		
		private function sha1_kt(t:Number):Number
		{
			return (t < 20) ? 1518500249 : (t < 40) ? 1859775393 : (t < 60) ? -1894007588 : -899497514;
		}
		
		private static function safe_add(x:Number, y:Number):Number
		{
			var lsw:Number=(x & 0xFFFF) + (y & 0xFFFF);
			var msw:Number=(x >> 16) + (y >> 16) + (lsw >> 16);
			return (msw << 16) | (lsw & 0xFFFF);
		}
		
		private function rol(num:Number, cnt:Number):Number
		{
			return (num << cnt) | (num >>> (32 - cnt));
		}
		
		private function str2binb(str:String):Array
		{
			var bin:Array=new Array();
			var mask:Number=(1 << 8) - 1;
			for (var i:int=0; i < str.length * 8; i+=8)
			{
				bin[i >> 5]|=(str.charCodeAt(i / 8) & mask) << (24 - i % 32);
			}
			return bin;
		}
		
		private function getHashString(v:uint):String
		{
			var s:String = v.toString(16);
			while (s.length < 4)
				s = "0" + s;
			return s;
		}
		
		public function toString():String
		{
			var a:Array = [];
			for (var i:int = 0;i < value.length;i++)
			{
				var v:uint = value[i];
				var v1:uint = (v >> 16) & 0xFFFF;
				var v2:uint = v & 0xFFFF;
				a.push(v1,v2);
			}
			
			return getHashString(a[0]) + getHashString(a[1]) + "-"
					+ getHashString(a[2]) + "-" + getHashString(a[3]) + "-" + getHashString(a[4]) + "-"
					+ getHashString(a[5]) + getHashString(a[6]) + getHashString(a[7])
		}
	}
}