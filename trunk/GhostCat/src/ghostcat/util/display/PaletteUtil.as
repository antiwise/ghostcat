package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 调色板 
	 * @author flashyiyi
	 * 
	 */
	public final class PaletteUtil
	{
		/**
		 * 获得调色板 
		 * @param light
		 * @return 
		 * 
		 */
		public static function getColorPaletter(light:uint = 0x80):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData(256,256);
			for (var j:int = 0;j < 256;j++)
			{
				for (var i:int = 0;i < 256;i++)
				{
					var c:uint = (i << 16) | (j << 8) | light;
					bitmapData.setPixel(i,255 - j,ColorConvertUtil.fromHSL(c))
				}
			}
			return bitmapData;
		}
		
		/**
		 * 获得亮度调色板
		 * @param color
		 * @return 
		 * 
		 */
		public static function getLightPaletter(color:uint = 0xFFFFFF):BitmapData
		{
			var hs:uint = (ColorConvertUtil.toHSL(color) >> 8) & 0xFFFF;
			var bitmapData:BitmapData = new BitmapData(1,256);
			for (var i:int = 0;i < 256;i++)
			{
				var c:uint = (hs << 8) | i;
				bitmapData.setPixel(0,255 - i,ColorConvertUtil.fromHSL(c))
			}
			return bitmapData;
		}
	}
}