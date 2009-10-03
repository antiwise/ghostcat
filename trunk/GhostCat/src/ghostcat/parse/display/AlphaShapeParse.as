package ghostcat.parse.display
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import ghostcat.parse.graphics.GraphicsGradientFillParse;
	import ghostcat.parse.graphics.GraphicsRect;
	
	/**
	 * 创造一个覆盖于图形上的渐变透明遮罩，目前用于拖动时显示的临时图元上
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class AlphaShapeParse extends RectParse
	{
		public function AlphaShapeParse(source:DisplayObject,alpha:Number=0.5,alphaWidth:Number=0.3)
		{
			var rect:Rectangle = source.getBounds(source);
			var graphicsRect:GraphicsRect = new GraphicsRect(rect.x,rect.y,rect.width,rect.height);
			var m:Matrix = new Matrix();
			m.createGradientBox(rect.width,rect.height,0,rect.x,rect.y);
			var graphicsFill:GraphicsGradientFillParse = new GraphicsGradientFillParse(GradientType.LINEAR,[0,0,0,0],[0,alpha,alpha,0],[0,255 * alphaWidth,255 * (1 - alphaWidth),255],m);
		
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