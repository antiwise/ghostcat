package org.ghostcat.parse.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.util.MathUtil;
	
	/**
	 * 绘制方框。这个类合并了原角和直角方框，以及一个指向箭头。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsRect extends DisplayParse
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		public var topLeftRadius:Number=NaN;
		public var topRightRadius:Number=NaN;
		public var bottomLeftRadius:Number=NaN;
		public var bottomRightRadius:Number=NaN;
		public var arowWidth:Number = 10;
		public var arowTo:Point;
		public var arowFrom:Point;
		
		public function GraphicsRect(x:Number,y:Number,width:Number,height:Number,topLeftRadius:Number=NaN,
			topRightRadius:Number=NaN,bottomLeftRadius:Number=NaN,bottomRightRadius:Number=NaN,
			arowTo:Point=null,arowWidth:Number=10,arowFrom:Point=null)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.topLeftRadius = topLeftRadius;
			this.topRightRadius = topRightRadius;
			this.bottomLeftRadius = bottomLeftRadius;
			this.bottomRightRadius = bottomRightRadius;
			this.arowWidth = arowWidth;
			this.arowTo = arowTo;
			this.arowFrom = arowFrom;
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			if (arowTo)
				drawRoundRectComplex(target,x,y,width,height,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius,arowTo,arowWidth,arowFrom);
			else if (isNaN(topLeftRadius) && isNaN(topRightRadius) && isNaN(bottomLeftRadius) && isNaN(bottomRightRadius))
				target.drawRect(x,y,width,height);
			else if (topLeftRadius && isNaN(topRightRadius) && isNaN(bottomLeftRadius) && isNaN(bottomRightRadius))
			{
				var minSize:Number = Math.min(width/2, height/2);
				topLeftRadius = Math.min(topLeftRadius,minSize);
				topRightRadius = Math.min(topLeftRadius,minSize);
				target.drawRoundRect(x,y,width,height,topLeftRadius*2,topLeftRadius*2);
			}
			else
				drawRoundRectComplex(target,x,y,width,height,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius,arowTo,arowWidth,arowFrom);
		}
		
		private function drawRoundRectComplex(graphics:Graphics,x:Number,y:Number,width:Number,height:Number,
			topLeftRadius:Number,topRightRadius:Number,bottomLeftRadius:Number,bottomRightRadius:Number,
			arowTo:Point=null,arowWidth:Number=10,arowFrom:Point=null):void
		{
			var minSize:Number = Math.min(width * 2,height * 2);
			if (isNaN(topLeftRadius)) topLeftRadius = 0;
			if (isNaN(topRightRadius)) topRightRadius = 0;
			if (isNaN(bottomLeftRadius)) bottomLeftRadius = 0;
			if (isNaN(bottomRightRadius)) bottomRightRadius = 0;
			topLeftRadius = Math.min(topLeftRadius , minSize);
			topRightRadius = Math.min(topRightRadius , minSize);
			bottomLeftRadius = Math.min(bottomLeftRadius , minSize);
			bottomRightRadius = Math.min(bottomRightRadius , minSize);
			
			var xw:Number = x + width;
			var yh:Number = y + height;
			
			var direct:int = -1;
			if (!arowFrom && arowTo)
				arowFrom = arowTo.clone();
			if (arowFrom)
			{
				if (arowFrom.y > yh)
				{
					direct = 0;
					arowFrom.x = MathUtil.limitIn(arowFrom.x,x + bottomLeftRadius + arowWidth/2,xw - bottomRightRadius - arowWidth/2);
				}
				else if (arowFrom.x < x)
				{
					direct = 1;	
					arowFrom.y = MathUtil.limitIn(arowFrom.y,y + topLeftRadius + arowWidth/2,yh - bottomLeftRadius - arowWidth/2);
				}
				else if (arowFrom.y < y)
				{
					direct = 2;
					arowFrom.x = MathUtil.limitIn(arowFrom.x,x + topLeftRadius + arowWidth/2,xw - topRightRadius - arowWidth/2);
				}
				else if (arowFrom.x > xw)
				{
					direct = 3;
					arowFrom.y = MathUtil.limitIn(arowFrom.y,y + topRightRadius + arowWidth/2,yh - bottomRightRadius - arowWidth/2);
				}
				
				var pw:Number = arowWidth / 2;
			}
				
			var paths:Array = [];
			
			// 缓存两个常数
			//
			// Math.rad = Math.PI / 180 = 0.0174532925199433
			// r * Math.sin(45 * Math.rad) =  (r * 0.707106781186547);
			// r * Math.tan(22.5 * Math.rad) = (r * 0.414213562373095);
			//
			// 1.0 - 0.707106781186547 = 0.292893218813453
			// 1.0 - 0.414213562373095 = 0.585786437626905
			const ak:Number = 0.292893218813453;
			const sk:Number = 0.585786437626905;
			
			// 右下角
			var a:Number = bottomRightRadius * ak;
			var s:Number = bottomRightRadius * sk;
			graphics.moveTo(xw, yh - bottomRightRadius);
			graphics.curveTo(xw, yh - s, xw - a, yh - a);
			graphics.curveTo(xw - s, yh, xw - bottomRightRadius, yh);
			
			if (direct == 0)
			{
				graphics.lineTo(arowFrom.x + pw,yh);
				graphics.lineTo(arowTo.x,arowTo.y);
				graphics.lineTo(arowFrom.x - pw,yh);
			}
			
			// 左下角
			a = bottomLeftRadius * ak;
			s = bottomLeftRadius * sk;
			graphics.lineTo(x + bottomLeftRadius, yh);
			graphics.curveTo(x + s, yh, x + a, yh - a);
			graphics.curveTo(x, yh - s, x, yh - bottomLeftRadius);
			
			if (direct == 1)
			{
				graphics.lineTo(x,arowFrom.y + pw);
				graphics.lineTo(arowTo.x,arowTo.y);
				graphics.lineTo(x,arowFrom.y - pw);
			}
			
			// 左上角
			a = topLeftRadius * ak;
			s = topLeftRadius * sk;
			graphics.lineTo(x, y + topLeftRadius);
			graphics.curveTo(x, y + s, x + a, y + a);
			graphics.curveTo(x + s, y, x + topLeftRadius, y);
			
			if (direct == 2)
			{
				graphics.lineTo(arowFrom.x - pw,y);
				graphics.lineTo(arowTo.x,arowTo.y);
				graphics.lineTo(arowFrom.x + pw,y);
			}
			
			// 右上角
			a = topRightRadius * ak;
			s = topRightRadius * sk;
			graphics.lineTo(xw - topRightRadius, y);
			graphics.curveTo(xw - s, y, xw - a, y + a);
			graphics.curveTo(xw, y + s, xw, y + topRightRadius);
			
			if (direct == 3)
			{
				graphics.lineTo(xw,arowFrom.y - pw);
				graphics.lineTo(arowTo.x,arowTo.y);
				graphics.lineTo(xw,arowFrom.y + pw);
			}
			
			graphics.lineTo(xw, yh - bottomRightRadius);
		}
	}
}