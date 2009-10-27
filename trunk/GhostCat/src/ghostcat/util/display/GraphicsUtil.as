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
		/**
		 * 绘制一个位图到画布上 
		 * @param target
		 * @param bitmapData
		 * @param pos
		 * 
		 */
		public static function drawBitmpData(target:Graphics,bitmapData:BitmapData,x:Number,y:Number,width:Number = NaN,height:Number = NaN):void
		{
			if (bitmapData)
			{
				var m:Matrix = new Matrix();
				m.translate(x,y);
				var sx:Number;
				var sy:Number;
				if (!isNaN(width))
					sx = width / bitmapData.width;
				if (!isNaN(height))
					sy = height / bitmapData.height;
				m.scale(sx,sy);
				
				target.beginBitmapFill(bitmapData,m,false,false);
				target.drawRect(x,y,width,height);
				target.endFill();
			}
		}
		
		/**
		 * 绘制一个扇形
		 *  
		 * @param target
		 * @param x
		 * @param y
		 * @param wradius
		 * @param hradius
		 * @param fromAngle
		 * @param toAngle
		 * 
		 */
		public static function drawSector(target:Graphics,x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number,toAngle:Number):void
		{
			var start:Number = fromAngle / 180 * Math.PI;
			if (toAngle % 360 != fromAngle % 360)
			{
				target.moveTo(x,y);
				target.lineTo(x + wradius * Math.cos(start),y + hradius * Math.sin(start));
			}
			else
			{
				target.moveTo(x + wradius * Math.cos(start),y + hradius * Math.sin(start));
			}
			
			drawCurve(target,x,y,wradius,hradius,fromAngle,toAngle);
			
			if (toAngle % 360 != fromAngle % 360)
				target.lineTo(x,y);
		}
		
		/**
		 * 绘制一个圆环
		 *  
		 * @param target
		 * @param x
		 * @param y
		 * @param wradius
		 * @param hradius
		 * @param fromAngle
		 * @param toAngle
		 * 
		 */
		public static function drawRing(target:Graphics,x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number,toAngle:Number,inner:Number):void
		{
			var p:Boolean = (toAngle % 360 != fromAngle % 360);
			
			var start:Number = fromAngle / 180 * Math.PI;
			if (p)
			{
				target.moveTo(x + wradius * Math.cos(start) * inner,y + hradius * Math.sin(start) * inner);
				target.lineTo(x + wradius * Math.cos(start),y + hradius * Math.sin(start));
			}
			else
			{
				target.moveTo(x + wradius * Math.cos(start),y + hradius * Math.sin(start));
			}
			
			drawCurve(target,x,y,wradius,hradius,fromAngle,toAngle);
			
			var end:Number = toAngle / 180 * Math.PI;
			if (p)
				target.lineTo(x + wradius * Math.cos(end) * inner,y + hradius * Math.sin(end) * inner);
			else
				target.moveTo(x + wradius * Math.cos(end) * inner,y + hradius * Math.sin(end) * inner);
			
			drawCurve(target,x,y,wradius * inner,hradius * inner,toAngle,fromAngle);
			
			if (p)
				target.lineTo(x + wradius * Math.cos(start),y + hradius * Math.sin(start));
		}
		
		private static function drawCurve(target:Graphics,x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number,toAngle:Number):void
		{
			var start:Number = fromAngle / 180 * Math.PI;
			var angle:Number = (toAngle - fromAngle) / 180 * Math.PI;
			var n:Number = Math.ceil(Math.abs(angle) / (Math.PI / 4));
			var angleS:Number = angle / n;
			for (var i:int = 1;i <= n;i++)
			{
				start += angleS;
				var angleMid:Number = start - angleS / 2;
				var bx:Number = x + wradius / Math.cos(angleS / 2) * Math.cos(angleMid);
				var by:Number = y + hradius / Math.cos(angleS / 2) * Math.sin(angleMid);
				var cx:Number = x + wradius * Math.cos(start);
				var cy:Number = y + hradius * Math.sin(start);
				target.curveTo(bx,by,cx,cy);
			}
		}
	}
}