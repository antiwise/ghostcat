package ghostcat.parse.display
{
	import flash.display.Graphics;
	
	import ghostcat.parse.graphics.GraphicsPath;
	import ghostcat.parse.graphics.IGraphicsFill;
	import ghostcat.parse.graphics.IGraphicsLineStyle;
	
	public class PathParse extends ShapeParse
	{
		public var points:Array;
		
		public function PathParse(points:Array, line:IGraphicsLineStyle=null, fill:IGraphicsFill=null,grid9:Grid9Parse=null)
		{
			super(null, line, fill, grid9);
			
			this.points = points;
		}

		protected override function parseBaseShape(target:Graphics) : void
		{
			super.parseBaseShape(target);
			
			if (points)
				new GraphicsPath(points).parseGraphics(target);
		}
	}
}