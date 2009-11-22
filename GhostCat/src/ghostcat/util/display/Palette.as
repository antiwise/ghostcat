package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 调色板 
	 * @author flashyiyi
	 * 
	 */
	public class Palette extends Bitmap
	{
		private var _light:uint = 0x80;
		public function Palette(light:uint = 0x80)
		{
			super(new BitmapData(256,256));
			this.light = light;
		}
		
		public function get light():int
		{
			return _light;
		}

		public function set light(value:int):void
		{
			_light = value;
			render();
		}

		public function render():void
		{
			for (var j:int = 0;j < 256;j++)
			{
				for (var i:int = 0;i < 256;i++)
				{
					var c:uint = (i << 16) | (j << 8) | light;
					bitmapData.setPixel(i,255 - j,ColorConvertUtil.fromHSL(c))
				}
			}
		}
	}
}