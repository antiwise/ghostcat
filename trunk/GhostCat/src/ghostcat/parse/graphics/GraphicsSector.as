package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.util.display.GraphicsUtil;
	
	/**
	 * 绘制扇形或环
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsSector extends DisplayParse
	{
		/**
		 * x坐标
		 */
		public var x:Number;
		/**
		 * y坐标
		 */
		public var y:Number;
		/**
		 * x轴半径 
		 */
		public var wradius:Number;
		/**
		 * y轴半径 
		 */
		public var hradius:Number;
		/**
		 * 起始角度(0-360)
		 */
		public var fromAngle:Number;
		/**
		 * 结束角度(0-360)
		 */
		public var toAngle:Number;
		
		/**
		 * 内环比例 
		 */
		public var inner:Number;
		
		public function GraphicsSector(x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number = 0,toAngle:Number = 360,inner:Number = NaN)
		{
			this.x = x;
			this.y = y;
			this.wradius = wradius;
			this.hradius = hradius;
			this.fromAngle = fromAngle;
			this.toAngle = toAngle;
			this.inner = inner;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			if (isNaN(inner))
				drawSector(target,x,y,wradius,hradius,fromAngle,toAngle);
			else
				drawRing(target,x,y,wradius,hradius,fromAngle,toAngle,inner);
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
		
		public static function drawCurve(target:Graphics,x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number,toAngle:Number):void
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