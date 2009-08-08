package org.ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import org.ghostcat.parse.DisplayParse;

	public class GraphicsFill extends DisplayParse
	{
		public var color:uint;
		public var alpha:Number = 1;
		public function GraphicsFill(color:uint,alpha:Number = 1)
		{
			this.color = color;
			this.alpha = alpha;
		}
		
		protected override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			target.beginFill(color,alpha);
		}
	}
}