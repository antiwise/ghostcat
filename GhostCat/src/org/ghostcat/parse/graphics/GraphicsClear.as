package org.ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import org.ghostcat.parse.DisplayParse;
	
	public class GraphicsClear extends DisplayParse
	{
		public function GraphicsClear()
		{
		}
		
		protected override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			target.clear();
		}
	}
}