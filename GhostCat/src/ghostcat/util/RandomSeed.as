package ghostcat.util
{
	import flash.utils.ByteArray;

	/**
	 * 伪随机数 
	 * @author flashyiyi
	 * 
	 */
	public class RandomSeed
	{
		private static const ADDEND:uint=11;
		private static const MULTIPLIER_HIGH:uint=0x5;
		private static const MULTIPLIER_MID:uint=0xDEEC;
		private static const MULTIPLIER_LOW:uint=0xE66D;
		
		private var seedHigh:uint;
		private var seedLow:uint;
		private var seedMid:uint;
		
		private static var seedExtra:uint=2353648897;
		
		/**
		 * 
		 * @param high
		 * @param low
		 * 
		 */
		public function RandomSeed(high:uint=0x80000000, low:uint=0)
		{
			if (high == 0x80000000 && low == 0)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.writeDouble(new Date().time);
				bytes.position = 0;
				high = bytes.readUnsignedInt() + seedExtra;
				low = bytes.readUnsignedInt() + (high >>> 16);
				seedExtra++;
			}
			setSeed(high, low);
			return;
		}
		
		public function setSeed(high:uint, low:uint):void
		{
			this.seedHigh = high & 0xFFFF ^ MULTIPLIER_HIGH;
			this.seedMid = low >> 16 & 0xFFFF ^ MULTIPLIER_MID;
			this.seedLow = low & 0xFFFF ^ MULTIPLIER_LOW;
		}
		
		private function next(max:uint):uint
		{
			var v2:Number = seedLow * MULTIPLIER_HIGH + seedMid * MULTIPLIER_MID + seedHigh * MULTIPLIER_LOW;
			var v3:Number = seedLow * MULTIPLIER_MID;
			var v4:Number = seedLow * MULTIPLIER_LOW;
			
			v2 = v2 + (v3 >>> 16);
			v3 = v3 & 0xFFFF;
			v3 = v3 + seedMid * MULTIPLIER_LOW;
			
			v2 = v2 + (v3 >>> 16);
			v3 = v3 & 0xFFFF;
			v3 = v3 + (v4 >>> 16);
			v2 = v2 + (v3 >>> 16);
			
			v4 = v4 & 0xFFFF;
			v3 = v3 & 0xFFFF;
			v2 = v2 & 0xFFFF;
			
			v4 = v4 + ADDEND;
			v3 = v3 + (v4 >>> 16);
			v2 = v2 + (v3 >>> 16);
			
			v4 = v4 & 0xFFFF;
			v3 = v3 & 0xFFFF;
			v2 = v2 & 0xFFFF;
			
			seedLow = v4;
			seedMid = v3;
			seedHigh = v2;
			
			if (max == 0)
				return 0;
			
			return (v2 << 16 | v3) >>> 32 - max;
		}
		
		public function nextInt(max:int):uint
		{
			var v2:Number;
			var v3:Number;
			
			if (max == 0 || !((max & 0x80000000) == 0))
				throw new Error();
			
			if ((max & -max) == max)
			{
				v2 = 0;
				if ((max & 0xFFFF0000) != 0)
					v2 = v2 + 16;
				
				if ((max & 0xFF00FF00) != 0)
					v2 = v2 + 8;
				
				if ((max & 0xF0F0F0F0) != 0)
					v2 = v2 + 4;
				
				if ((max & 0xCCCCCCCC) != 0)
					v2 = v2 + 2;
				
				if ((max & 0xAAAAAAAA) != 0)
					v2 = v2 + 1;
				
				return next(v2);
			}
			do 
			{
				v2 = next(0x1F);
				v3 = v2 % max;
			}
			while (v2 - v3 + max - 1 < 0);
			return v3;
		}
	}
}


