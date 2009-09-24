package ghostcat.parse.display
{
	import flash.display.Graphics;
	
	import ghostcat.parse.graphics.GraphicsPath;
	import ghostcat.parse.graphics.IGraphicsFill;
	import ghostcat.parse.graphics.IGraphicsLineStyle;
	
	/**
	 * 线条
	 * @author flashyiyi
	 * 
	 */
	public class PathParse extends ShapeParse
	{
		/**
		 * 点的数组 
		 */
		public var points:Array;
		
		public function PathParse(points:Array, line:IGraphicsLineStyle=null, fill:IGraphicsFill=null,grid9:Grid9Parse=null)
		{
			super(null, line, fill, grid9);
			
			this.points = points;
		}
		/** @inheritDoc*/
		protected override function parseBaseShape(target:Graphics) : void
		{
			super.parseBaseShape(target);
			
			if (points)
				new GraphicsPath(points).parseGraphics(target);
		}
	}
}