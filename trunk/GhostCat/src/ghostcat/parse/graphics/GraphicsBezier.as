package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ghostcat.algorithm.bezier.Bezier;
	import ghostcat.parse.DisplayParse;
	
	/**
	 * 弧线 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsBezier extends DisplayParse
	{
		public var target:Graphics;
		public var start:Point;
		public var control:Point;
		public var end:Point;
		public var dash:Number = NaN;
		public var dashStart:Number = 0.0;
		public function GraphicsBezier(start:Point,control:Point,end:Point,dash:Number = NaN,dashStart:Number = 0.0)
		{
			super();
			
			this.start = start;
			this.control = control;
			this.end = end;
			this.dash = dash;
			this.dashStart = dashStart;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			drawBezier(target,start,control,end,dash,dashStart);			
		}
		
		/**
		 * 绘制弧线
		 * 
		 * @param target
		 * @param start
		 * @param control
		 * @param end
		 * @param dash
		 * @param dashStart
		 * 
		 */
		public static function drawBezier(target:Graphics,start:Point,control:Point,end:Point,dash:Number = NaN,dashStart:Number = 0.0):void
		{
			new Bezier(start,control,end).parse(target,dash,dashStart);
		}
	}
}