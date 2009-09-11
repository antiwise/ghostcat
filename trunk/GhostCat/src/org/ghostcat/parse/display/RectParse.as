package org.ghostcat.parse.display
{
	import flash.display.Graphics;
	
	import org.ghostcat.parse.graphics.GraphicsRect;
	import org.ghostcat.parse.graphics.IGraphicsFill;
	import org.ghostcat.parse.graphics.IGraphicsLineStyle;
	
	public class RectParse extends ShapeParse
	{
		public var rect:GraphicsRect;
		
		public function RectParse(rect:GraphicsRect, line:IGraphicsLineStyle=null, fill:IGraphicsFill=null,grid9:Grid9Parse=null)
		{
			super(null, line, fill, grid9);
			
			this.rect = rect;
		}
		
		public override function parseShape(target:Graphics) : void
		{
			super.parseGraphics(target);
			
			if (rect)
				rect.parseGraphics(target);	
		}
	}
}