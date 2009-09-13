package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;
	
	public class GraphicsEndFill extends DisplayParse
	{
		public function GraphicsEndFill()
		{
			
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			target.endFill();
		}
	}
}