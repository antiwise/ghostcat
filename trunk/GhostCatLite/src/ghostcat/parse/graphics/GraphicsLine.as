package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ghostcat.parse.DisplayParse;
	
	/**
	 * 绘制直线
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsLine extends DisplayParse
	{
		public var start:Point;
		public var end:Point;
		public var d:Number;
		public var dr:Number;
		public function GraphicsLine(start:Point = null, end:Point = null, d:Number = NaN, dr:Number = 0.0)
		{
			this.start = start;
			this.end = end;
			this.d = d;
			this.dr = dr;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			lineTo(target,start,end,d,dr);
		}
		
		public static function lineTo(target:Graphics, start:Point = null, end:Point = null, dash:Number = NaN, dashStart:Number = 0.0):void
		{
			if (!isNaN(dashStart) && start && end)
			{
				var offest:Point = end.subtract(start);
				var len:int = offest.length / (dash + dash);
				var dl:Number = 1 / len;
				var sl:Number = dl * dashStart;
				for (var i:int = 0;i < len;i++)
				{
					var s:Point = Point.interpolate(start,end, dl * i + sl);
					var e:Point = Point.interpolate(start,end, dl * i + dl / 2 + sl);
					target.moveTo(s.x,s.y);
					target.lineTo(e.x,e.y);
				}
			}
			else
			{
				if (start)
					target.moveTo(start.x,start.y);
				if (end)
					target.lineTo(end.x,end.y);
			}
		}
	}
}