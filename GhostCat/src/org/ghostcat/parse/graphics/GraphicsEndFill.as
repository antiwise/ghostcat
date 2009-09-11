package org.ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import org.ghostcat.parse.DisplayParse;
	
	public class GraphicsEndFill extends DisplayParse
	{
		public function GraphicsEndFill()
		{
			
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			super.parse(target);
			target.endFill();
		}
	}
}