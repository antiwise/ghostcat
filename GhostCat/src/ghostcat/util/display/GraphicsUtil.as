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
		
		public static function drawSector(target:Graphics,x:Number,y:Number,radius:Number,fromAngle:Number,toAngle:Number):void
		{
			target.moveTo(x,y);
			var angle:Number = (toAngle - fromAngle) / 180 * Math.PI;
			var n:Number = Math.ceil(Math.abs(angle) / (Math.PI / 4));
			var angleS:Number = angle / n;
			
			var start:Number = fromAngle / 180 * Math.PI;
			target.lineTo(x + radius * Math.cos(start),y + radius * Math.sin(start));
			
			for (var i:int = 1;i <= n;i++)
			{
				start += angleS;
				var angleMid:Number = start - angleS / 2;
				var bx:Number = x + radius / Math.cos(angleS / 2) * Math.cos(angleMid);
				var by:Number = y + radius / Math.cos(angleS / 2) * Math.sin(angleMid);
				var cx:Number = x + radius * Math.cos(start);
				var cy:Number = y + radius * Math.sin(start);
				target.curveTo(bx,by,cx,cy);
			}
			if (angle != 360)
				target.lineTo(x,y);
		}
	}
}