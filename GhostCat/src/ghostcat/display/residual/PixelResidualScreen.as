package ghostcat.display.residual
{
	import flash.display.BitmapData;

	/**
	 * 在ResidualScreen的基础上增加了渲染像素对象的功能
	 * @see ghostcat.display.residual.PixelItem
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class PixelResidualScreen extends ResidualScreen
	{
		public function PixelResidualScreen(width:Number,height:Number)
		{
			super(width,height);
		}
		/** @inheritDoc*/
		protected override function drawItem(obj:*):void
		{
			if (obj is PixelItem)
			{
				var pixel:PixelItem = obj as PixelItem;
				bitmapData.setPixel32(pixel.x,pixel.y,pixel.color);
			}
			else
				super.drawItem(obj);
		} 
	}
}