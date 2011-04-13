package ghostcat.display.transfer.effect
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import ghostcat.util.core.Handler;

	/**
	 * 爆炸效果
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class BombHandler extends Handler
	{
		public var scale:Number;
		public function BombHandler(scale:Number = 2):void
		{
			super();
			this.scale = scale;
		}
		
		public override function call(...params):*
		{
			var normalBitmapData:BitmapData = params[0];
			var bitmapData:BitmapData = params[1];
			var deep:Number = params[2];
			
			bitmapData.fillRect(bitmapData.rect,0);
			var bx:int = bitmapData.width * (1 - 1 / scale) / 2;
			var by:int = bitmapData.height* (1 - 1 / scale) / 2;
			var mx:int = bitmapData.width / 2;
			var my:int = bitmapData.height / 2;
			for (var j:int = by;j < bitmapData.height - by;j++)
			{
				for (var i:int = bx;i < bitmapData.width - bx;i++)
				{
					var p:Point = new Point(i - mx,j - my);
					p.normalize(p.length * (1 + (scale - 1) * deep));
					bitmapData.setPixel32(mx + p.x,my + p.y,normalBitmapData.getPixel32(i,j));
				}
			}			
		}
	}
}