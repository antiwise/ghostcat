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
		public var channel:int;
		public function ThresholdHandler(channel:uint = 0xFFFFFF):void
		{
			super();
			this.channel = channel;
		}
		
		public override function call(...params):*
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
			bitmapData.threshold(normalBitmapData, normalBitmapData.rect, new Point(), ">", (1 - deep) * channel, 0, channel, true);
		}
	}
}