package ghostcat.util.display
{
	/**
	 * 色彩制式转换类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class ColorConvertUtil
	{
		/**
		 * CYM(蓝黄红)转换为RGB
		 */		
		public static function fromCYM(v:uint):uint
		{
			var A:int = (v >> 24) & 0xFF;
			var C:int = (v >> 16) & 0xFF;
			var M:int = (v >> 8) & 0xFF;
			var Y:int = v & 0xFF;
			return (A << 24) | ((0xFF - Y) << 16) | ((0xFF - C) << 8) | (0xFF - M);
		}
		
		/**
		 * CYM转换为RGB
		 */		
		public static function toCYM(v:uint):uint
		{
			var A:int = (v >> 24) & 0xFF;
			var R:int = (v >> 16) & 0xFF;
			var G:int = (v >> 8) & 0xFF;
			var B:int = v & 0xFF;
			return (A << 24) | ((0xFF - G) << 16) | ((0xFF - B) << 8) | (0xFF - R);	
		}
		
		/**
		 * HSL转换为RGB
		 */		
		public static function fromHSL(v:uint):uint
		{
			var A:int = (v >> 24) & 0xFF;
			var H:int = (v >> 16) & 0xFF;
			var S:int = (v >> 8) & 0xFF;
			var L:int = v & 0xFF;
			
			var R:int;
			var G:int;
			var B:int;
			var var_1:int;
			var var_2:int;
			
			if (S == 0) 
			{
				R = L * 0xFF;
				G = L * 0xFF;
				B = L * 0xFF;
			}
			else
			{
				if (L < 0.5)
					var_2 = L * (1 + S);
				else
					var_2 = (L + S) - (S * L);
				
				var_1 = 2 * L - var_2;
				
				R = 0xFF * Hue2RGB(var_1, var_2, H + 1 / 3);
				G = 0xFF * Hue2RGB(var_1, var_2, H);
				B = 0xFF * Hue2RGB(var_1, var_2, H - 1 / 3);
			}
			return (A << 24) | (R << 16) | (G << 8) | B;	
		}
		
		private static function Hue2RGB(v1:Number, v2:Number, vH:Number):Number
		{
			if (vH < 0) 
				vH += 1;
			if (vH > 1) 
				vH -= 1;
			if (6 * vH < 1) 
				return v1 + (v2 - v1) * 6.0 * vH;
			if (2 * vH < 1) 
				return v2;
			if (3 * vH < 2) 
				return v1 + (v2 - v1) * (2 / 3 - vH) * 6.0;
			return v1;
		}
		
		/**
		 * RGB转换为HSL
		 */		
		public static function toHSL(v:uint):uint
		{
			var A:int = (v >> 24) & 0xFF;
			var R:int = (v >> 16) & 0xFF;
			var G:int = (v >> 8) & 0xFF;
			var B:int = v & 0xFF;
			
			var Min:int = Math.min(R, Math.min(G, B));
			var Max:int = Math.max(R, Math.max(G, B)); 
			
			var H:int;
			var S:int;
			var L:int = (Max + Min) / 2;
			
			var del_Max:int = Max - Min;
			if (del_Max == 0) 
			{
				H = S = 0;
			}
			else
			{
				if (L < 0.5)
					S = del_Max / (Max + Min);
				else         
					S = del_Max / (2 - Max - Min);
				
				var del_R:Number = ((Max - R) / 6 + del_Max / 2) / del_Max;
				var del_G:Number = ((Max - G) / 6 + del_Max / 2) / del_Max;
				var del_B:Number = ((Max - B) / 6 + del_Max / 2) / del_Max;
				
				if (R == Max) 
					H = del_B - del_G;
				else if (G == Max) 
					H = 1 / 3 + del_R - del_B;
				else if (B == Max) 
					H = 2 / 3 + del_G - del_R;
				
				if (H < 0)
					H += 1;
				
				if (H > 1)
					H -= 1;
			}
			return (A << 24) | (H << 16) | (S << 8) | L;	
		}
	}
}