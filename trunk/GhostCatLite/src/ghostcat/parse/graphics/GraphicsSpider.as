package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;
	
	public class GraphicsSpider extends DisplayParse
	{
		public var x:Number;
		public var y:Number;
		public var radius:Number;
		public var length:int;
		public function GraphicsSpider(x:Number,y:Number,radius:Number,length:int)
		{
			super();
			
			this.x = x;
			this.y = y;
			this.radius = radius;
			this.length = length;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			drawSpider(target,x,y,radius,length);			
		}
		
		/**
		 * 绘制一个放射线
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
		public static function drawSpider(target:Graphics,x:Number,y:Number,radius:Number,length:int):void
		{
			var dr:Number = Math.PI * 2 / length;
			for (var i:int = 0;i < length;i++)
			{
				target.moveTo(x,y);
				target.lineTo(x + Math.cos(dr * i) * radius,y + Math.sin(dr * i) * radius);
			}
		}
	}
}