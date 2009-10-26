package ghostcat.display.transfer.effect
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ghostcat.util.core.Handler;

	/**
	 * 阈值
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class ThresholdHandler extends Handler
	{
		public function ThresholdHandler():void
		{
			super(null);
		}
		
		public override function call(...params):*
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
			bitmapData.threshold(normalBitmapData, normalBitmapData.rect, new Point(), ">", (1 - deep) * 255, 0, 255, true);
		}
	}
}