package ghostcat.util.data
{
	import mx.collections.Sort;

	/**
	 * 大数计算
	 * @author flashyiyi
	 * 
	 */
	public final class BigNumberUtil
	{
		/**
		 * 加法
		 * @param v1
		 * @param v2
		 * @return 
		 * 
		 */
		public static function add(n1:String,n2:String):String
		{
			var b1:Boolean = (n1.charAt(0) == "-");
			var b2:Boolean = (n2.charAt(0) == "-");
			if (b1 && b2)
				return addFunction(n1.slice(1,n1.length),n2.slice(1,n2.length),true);
			else if (b1)
				return subFunction(n2,n1.slice(1,n1.length));
			else if (b2)
				return subFunction(n1,n2.slice(1,n2.length));
			else
				return addFunction(n1,n2);
		}
		
		/**
		 * 减法
		 * @param v1
		 * @param v2
		 * @return 
		 * 
		 */
		public static function sub(n1:String,n2:String):String
		{
			var b1:Boolean = (n1.charAt(0) == "-");
			var b2:Boolean = (n2.charAt(0) == "-");
			if (b1 && b2)
				return subFunction(n2.slice(1,n2.length),n1.slice(1,n1.length));
			else if (b1)
				return addFunction(n2,n1.slice(1,n1.length),true);
			else if (b2)
				return addFunction(n1,n2.slice(1,n2.length));
			else
				return subFunction(n1,n2);
		}
		
		/**
		 * 乘法
		 * @param v1
		 * @param v2
		 * @return 
		 * 
		 */
		public static function mul(n1:String,n2:String):String
		{
			var b1:Boolean = (n1.charAt(0) == "-");
			var b2:Boolean = (n2.charAt(0) == "-");
			if (b1 && b2)
				return mulFunction(n2.slice(1,n2.length),n1.slice(1,n1.length));
			else if (b1)
				return mulFunction(n2,n1.slice(1,n1.length),true);
			else if (b2)
				return mulFunction(n1,n2.slice(1,n2.length),true);
			else
				return mulFunction(n1,n2);
		}
		
		/**
		 * 比较大小
		 * @param v1
		 * @param v2
		 * @return 
		 * 
		 */
		public static function compare(n1:String,n2:String):int
		{
			var l1:int = n1.length;
			var l2:int = n2.length;
			if (l1 > l2)
				return 1;
			else if (l1 < l2)
				return -1;
			else 
			{
				for (var i:int = 0; i < l1; i++)
				{
					var bit1:int = n1.charCodeAt(i);
					var bit2:int = n2.charCodeAt(i);
					if (bit1 > bit2)
						return 1;
					else if (bit1 < bit2)
						return -1;
				}
			}
			return 0;
		}
		
		
		private static function addFunction(n1:String,n2:String,bool:Boolean = false):String
		{
			var bit1:int;
			var bit2:int;
			var bit3:int;
			var carry:int = 0;
			
			var answer:String = "";
			var l1:int = n1.length;
			var l2:int = n2.length;
			var l:int = Math.max(l1,l2);
			
			for (var i:int = 0; i < l; i++)
			{
				bit1 = (i < l1) ? n1.charCodeAt(l1 - i - 1) - 0x30 : 0;
				bit2 = (i < l2) ? n2.charCodeAt(l2 - i - 1) - 0x30 : 0;
				bit3 = bit1 + bit2 + carry;
				if (bit3 >= 10)
				{
					bit3 -= 10;
					carry = 1;
				}
				else
				{
					carry = 0;
				}
				answer = String.fromCharCode(0x30 + bit3) + answer;
			}
			if (carry == 1)
				answer = "1" + answer;
			
			answer = (bool ? "-" : "") + trim(answer);
			return answer;
		}
		
		private static function subFunction(n1:String,n2:String,bool:Boolean = false):String
		{
			var bit1:int;
			var bit2:int;
			var bit3:int;
			var carry:int = 0;
			
			if (compare(n1,n2) == -1)
			{
				var t:String = n1;
				n1 = n2;
				n2= t;
				
				bool = !bool;
			}
			
			var answer:String = "";
			var l1:int = n1.length;
			var l2:int = n2.length;
			var l:int = Math.max(l1,l2);
			
			for (var i:int = 0; i < l; i++)
			{
				bit1 = (i < l1) ? n1.charCodeAt(l1 - i - 1) - 0x30 : 0;
				bit2 = (i < l2) ? n2.charCodeAt(l2 - i - 1) - 0x30 : 0;
				bit3 = bit1 - bit2 + carry;
				if (bit3 < 0)
				{
					bit3 += 10;
					carry = -1;
				}
				else
				{
					carry = 0;
				}
				answer = String.fromCharCode(0x30 + bit3) + answer;
			}
			answer = (bool ? "-" : "") + trim(answer);
			return answer;
		}
		
		private static function mulFunction(n1:String,n2:String,bool:Boolean = false):String
		{
			var bit1:int;
			var bit2:int;
			var bit3:int;
			
			var answer:String = "";
			var l1:int = n1.length;
			var l2:int = n2.length;
			var space:Array = new Array(l1 + l2 - 1);
			
			for (var i:int = 0; i < l1; i++)
			{
				for (var j:int = 0;j < l2;j++)
				{
					bit1 = n1.charCodeAt(l1 - i - 1) - 0x30;
					bit2 = n2.charCodeAt(l2 - j - 1) - 0x30;
					bit3 = bit1 * bit2;
					space[i + j] = int(space[i + j]) + bit3;
				}
			}
			var carry:int = 0;
			for (i = 0; i < space.length; i++)
			{
				bit1 = space[i];
				bit3 = (bit1 + carry) % 10;
				carry = int((bit1 + carry) / 10);
				answer = String.fromCharCode(0x30 + bit3) + answer;
			}
			if (carry)
				answer = String.fromCharCode(0x30 + carry) + answer;
			
			answer = (bool ? "-" : "") + trim(answer);
			return answer;
		}
		
		static private function trim(n:String):String
		{
			var l:int = n.length;
			for (var i:int = 0;i < l - 1;i++)
			{
				if (n.charCodeAt(i) != 0x30)
					break;
			}
			
			return n.slice(i,n.length);
		}
	}
}

