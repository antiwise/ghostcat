package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ghostcat.parse.DisplayParse;
	
	/**
	 * 绘制矩形扇形
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsRectSector extends DisplayParse
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
		
		public function GraphicsRectSector(x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number = 0,toAngle:Number = 360)
		{
			this.x = x;
			this.y = y;
			this.wradius = wradius;
			this.hradius = hradius;
			this.fromAngle = fromAngle;
			this.toAngle = toAngle;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			drawRectSector(target,x,y,wradius,hradius,fromAngle,toAngle);
		}
		
		/**
		 * 绘制一个矩形扇形
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
		public static function drawRectSector(target:Graphics,x:Number,y:Number,wradius:Number,hradius:Number,fromAngle:Number,toAngle:Number):void
		{
			const PI1_4:Number = Math.PI / 4;
			var start:Number = fromAngle / 180 * Math.PI;
			var end:Number = toAngle / 180 * Math.PI;
			var p:Point = getOffest(wradius,hradius,start);
			if (toAngle % 360 != fromAngle % 360)
			{
				target.moveTo(x,y);
				target.lineTo(x + p.x,y + p.y);
			}
			else
			{
				target.moveTo(x + p.x,y + p.y);
			}
			
			start = Math.floor(start / PI1_4) * PI1_4;
			var angle:Number = end - start;
			var n:int = Math.abs(angle) / PI1_4;
			
			for (var i:int = 0;i < n;i++)
			{
				start += PI1_4;
				p = getOffest(wradius,hradius,start);
				target.lineTo(x + p.x,y + p.y);
			}
			p = getOffest(wradius,hradius,end);
			target.lineTo(x + p.x,y + p.y);
			
			if (toAngle % 360 != fromAngle % 360)
				target.lineTo(x,y);
		}
		
		private static function getOffest(wradius:Number,hradius:Number,angle:Number):Point
		{
			const PI2:Number = Math.PI * 2;
			angle = angle % PI2;
			if (angle < 0)
				angle += PI2;
			
			var p:Point;
			//y = Math.tan(angle) * x;
			if (angle > PI2 * 0.875 || angle < PI2 * 0.125)//right x = wradius
				p = new Point(wradius,Math.tan(angle) * wradius);
			else if (angle > PI2 * 0.625)//top y = -hradius
				p = new Point(-hradius / Math.tan(angle),-hradius);
			else if (angle > PI2 * 0.375)//left y = -wradius;
				p = new Point(-wradius,Math.tan(angle) * -wradius);
			else //bottom y = hradius;
				p = new Point(hradius / Math.tan(angle),hradius);
			
			return p;
		}
	}
}