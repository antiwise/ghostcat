package org.ghostcat.parse.display
{
	import flash.display.Graphics;
	
	import org.ghostcat.parse.graphics.GraphicsEllipse;
	import org.ghostcat.parse.graphics.IGraphicsFill;
	import org.ghostcat.parse.graphics.IGraphicsLineStyle;

	public class EllipseParse extends ShapeParse
	{
		public var ellipse:GraphicsEllipse;
		
		public function EllipseParse(ellipse:GraphicsEllipse, line:IGraphicsLineStyle=null, fill:IGraphicsFill=null,grid9:Grid9Parse=null)
		{
			super(null, line, fill, grid9);
			
			this.ellipse = ellipse;
		}
		
		public override function parseShape(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			if (ellipse)
				ellipse.parseGraphics(target);
		}
	}
}