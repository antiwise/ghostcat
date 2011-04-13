package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;

	public class GraphicsFill extends DisplayParse implements IGraphicsFill
	{
		public var color:uint;
		public var alpha:Number = 1.0;
		public function GraphicsFill(color:uint,alpha:Number = NaN)
		{
			if (isNaN(alpha))
			{
				var colorAlpha:Number = ((color >> 24) & 0xFF) / 0xFF;
				if (colorAlpha != 0.0)
					alpha = colorAlpha;
				else
					alpha = 1.0;
			}
			
			this.color = color;
			this.alpha = alpha;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			target.beginFill(color,alpha);
		}
	}
}