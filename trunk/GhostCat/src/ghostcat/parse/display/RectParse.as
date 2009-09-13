package ghostcat.parse.display
{
	import flash.display.Graphics;
	
	import ghostcat.parse.graphics.GraphicsRect;
	import ghostcat.parse.graphics.IGraphicsFill;
	import ghostcat.parse.graphics.IGraphicsLineStyle;
	
	public class RectParse extends ShapeParse
	{
		public var rect:GraphicsRect;
		
		public function RectParse(rect:GraphicsRect, line:IGraphicsLineStyle=null, fill:IGraphicsFill=null,grid9:Grid9Parse=null)
		{
			super(null, line, fill, grid9);
			
			this.rect = rect;
		}
		
		protected override function parseBaseShape(target:Graphics) : void
		{
			super.parseBaseShape(target);
			
			if (rect)
				rect.parseGraphics(target);	
		}
	}
}