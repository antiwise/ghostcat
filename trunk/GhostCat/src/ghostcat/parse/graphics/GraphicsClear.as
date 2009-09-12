package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;
	
	public class GraphicsClear extends DisplayParse
	{
		public function GraphicsClear()
		{
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			target.clear();
		}
	}
}