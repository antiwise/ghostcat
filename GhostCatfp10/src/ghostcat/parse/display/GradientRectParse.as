package ghostcat.parse.display
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ghostcat.parse.graphics.GraphicsGradientFillParse;
	import ghostcat.parse.graphics.GraphicsRect;
	
	/**
	 * 创造一个渐变透明矩形
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GradientRectParse extends RectParse
	{
		public function GradientRectParse(rect:Rectangle,rotation:Number = 0.0,color:uint = 0x0,fromRatio:int = 0.0,toRatio:Number = 1.0)
		{
			var graphicsRect:GraphicsRect = new GraphicsRect(rect.x,rect.y,rect.width,rect.height);
			var m:Matrix = new Matrix();
			m.createGradientBox(rect.width,rect.height,rotation / 180 * Math.PI,rect.x,rect.y);
			var graphicsFill:GraphicsGradientFillParse = new GraphicsGradientFillParse(GradientType.LINEAR,[color,color],[1,0],[255 * fromRatio,255 * toRatio],m);
		
			super(graphicsRect,null,graphicsFill);
		}
		
		/** @inheritDoc*/
		public override function createShape() : Shape
		{
			var s:Shape = super.createShape();
			s.blendMode = BlendMode.ALPHA;
			return s;
		}
		/** @inheritDoc*/
		public override function createSprite() : Sprite
		{
			var s:Sprite = super.createSprite();
			s.blendMode = BlendMode.ALPHA;
			return s;
		}
		/** @inheritDoc*/
		public override function parseBitmapData(target:BitmapData) : void
		{
			target.draw(createShape(),null,null,BlendMode.ALPHA);
		}
		/** @inheritDoc*/
		public override function parseContainer(target:DisplayObjectContainer) : void
		{
			super.parseContainer(target);
			
			target.blendMode = BlendMode.LAYER;
		}
		
	}
}