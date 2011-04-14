package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;
	
	public class GraphicsEllipse extends DisplayParse
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public function GraphicsEllipse(x:Number,y:Number,width:Number,height:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			if (width == height)
				target.drawCircle(x,y,width/2);
			else
				target.drawEllipse(x,y,width,height);
		}
	}
}