package ghostcat.util.display
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * Graphics辅助类 
	 * @author flashyiyi
	 * 
	 */
	public final class GraphicsUtil
	{
		public static function drawBitmpData(target:Graphics,bitmapData:BitmapData,pos:Point = null):void
		{
			if (bitmapData)
			{
				var p:Point = pos;
				if (!p)
					p = new Point();
				
				var m:Matrix = new Matrix();
				m.translate(p.x,p.y);
				
				target.beginBitmapFill(bitmapData,m,false,false);
				target.drawRect(p.x,p.y,bitmapData.width,bitmapData.height);
				target.endFill();
			}
		}
	}
}