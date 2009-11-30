package ghostcat.util.display
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ghostcat.algorithm.bezier.Bezier;
	import ghostcat.parse.graphics.GraphicsBitmapFill;
	import ghostcat.parse.graphics.GraphicsLine;
	import ghostcat.parse.graphics.GraphicsRect;
	import ghostcat.parse.graphics.GraphicsSector;

	/**
	 * Graphics辅助类 
	 * @author flashyiyi
	 * 
	 */
	public final class GraphicsUtil
	{
		/**
		 * 绘制虚线直线 
		 * @param target
		 * @param start
		 * @param end
		 * @param dash
		 * @param dashStart
		 * 
		 */
		public static function lineTo(target:Graphics, start:Point = null, end:Point = null, dash:Number = NaN, dashStart:Number = 0.0):void
		{
			GraphicsLine.lineTo(target, start, end, dash, dashStart);
		}
		
		/**
		 * 绘制虚线弧线 
		 * @param target
		 * @param start
		 * @param control
		 * @param end
		 * @param dash
		 * @param dashStart
		 * 
		 */
		public static function curveTo(target:Graphics, start:Point = null, control:Point = null, end:Point = null, dash:Number = NaN, dashStart:Number = NaN):void
		{
			new Bezier(start,control,end).parse(target,dash,dashStart);
		}
		
		/**
		 * 绘制位图 
		 * @param target
		 * @param bitmapData
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * 
		 */
		public static function drawBitmapData(target:Graphics,bitmapData:BitmapData,x:Number,y:Number,width:Number = NaN,height:Number = NaN):void
		{
			GraphicsBitmapFill.drawBitmpData(target,bitmapData,x,y,width,height);
		}
		
		/**
		 * 绘制圆角矩形 
		 * @param target
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param topLeftRadius
		 * @param topRightRadius
		 * @param bottomLeftRadius
		 * @param bottomRightRadius
		 * @param arowTo
		 * @param arowWidth
		 * @param arowFrom
		 * 
		 */
		public static function drawRoundRect(target:Graphics,x:Number,y:Number,width:Number,height:Number,
											 topLeftRadius:Number,topRightRadius:Number,bottomLeftRadius:Number,bottomRightRadius:Number,
											 arowTo:Point=null,arowWidth:Number=10,arowFrom:Point=null):void
		{
			GraphicsRect.drawRoundRectComplex(target,x,y,width,height,topLeftRadius,topRightRadius,bottomLeftRadius,bottomRightRadius,arowTo,arowWidth,arowFrom);
		}
		
		/**
		 * 绘制扇形 
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
			GraphicsSector.drawSector(target,x,y,wradius,hradius,fromAngle,toAngle)
		}
		
		/**
		 * 绘制圆环 
		 * @param target
		 * @param x
		 * @param y
		 * @param wradius
		 * @param hradius
		 * @param fromAngle
		 * @param toAngle
		 * @param inner
		 * 
		 */
		public static function drawRing(target:Graphics,x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number,toAngle:Number,inner:Number):void
		{
			GraphicsSector.drawRing(target,x,y,wradius,hradius,fromAngle,toAngle,inner)
		}
	}
}