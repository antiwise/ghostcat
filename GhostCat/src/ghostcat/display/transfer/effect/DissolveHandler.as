package ghostcat.display.transfer.effect
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ghostcat.util.core.Handler;

	/**
	 * 溶解
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class DissolveHandler extends Handler
	{
		/**
		 * 随机因子 
		 */
		public var randSeed:int = new Date().getTime();
		
		public function DissolveHandler(randSeed:int = 0):void
		{
			if (randSeed == 0)
				randSeed = new Date().getTime();
			this.randSeed = randSeed;
			
			super(null);
		}
		
		/** @inheritDoc*/
		public override function call(...params) : *
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
			bitmapData.pixelDissolve(normalBitmapData,normalBitmapData.rect,new Point(),randSeed,(1 - deep) * bitmapData.width * bitmapData.height);
		}
	}
}