package ghostcat.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class DissolveTransfer extends GBitmapCacheTransfer
	{
		/**
		 * 随机因子
		 */
		public var randSeed:int = getTimer();
		
		public function DissolveTransfer(target:DisplayObject)
		{
			this.command = renderDissolve;
			super(target);
		}
		
		private function renderDissolve(normalBitmapData:BitmapData) : void
		{
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.pixelDissolve(normalBitmapData,normalBitmapData.rect,new Point(),randSeed,(1 - deep) * bitmapData.width * bitmapData.height);
		}
	}
}