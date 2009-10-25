package ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class ThresholdTransfer extends GBitmapCacheTransfer
	{
		public function ThresholdTransfer(target:DisplayObject)
		{
			this.command = renderThreshold;
			super(target);
		}
		
		private function renderThreshold(normalBitmapData:BitmapData) : void
		{
			bitmapData.threshold(normalBitmapData, normalBitmapData.rect, new Point(), ">", (1 - deep) * 255, 0, 255, true);
		}
	}
}