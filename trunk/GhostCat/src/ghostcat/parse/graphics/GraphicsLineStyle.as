package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	
	import ghostcat.parse.DisplayParse;

	public class GraphicsLineStyle extends DisplayParse implements IGraphicsLineStyle
	{
		public var thickness:Number;
		public var color:uint;
		public var alpha:Number;
		public var pixelHinting:Boolean;
		public var scaleMode:String;
		public var caps:String;
		public var joints:String;
		public var miterLimit:Number;
		public function GraphicsLineStyle(thickness:Number = NaN,color:uint=0,alpha:Number=1,pixelHinting:Boolean=false,scaleMode:String="normal",caps:String=null,joints:String=null,miterLimit:Number=3)
		{
			this.thickness = thickness;
			this.color = color;
			this.alpha = alpha;
			this.pixelHinting = pixelHinting;
			this.scaleMode = scaleMode;
			this.caps = caps;
			this.joints = joints;
			this.miterLimit = miterLimit;
		}
		
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			target.lineStyle(thickness,color,alpha,pixelHinting,scaleMode,caps,joints,miterLimit);
		}
	}
}