package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import ghostcat.display.game.SpinGravitationItem;
	import ghostcat.display.transfer.RadialBlur;
	import ghostcat.filter.ColorMatrixFilterProxy;
	
	
	public class SpinGravitatinoItemExample extends Sprite
	{
		public var body:Shape;
		public var target:Shape;
		public var item:SpinGravitationItem;
		public function SpinGravitatinoItemExample()
		{
			body = new Shape();
			body.x = 50;
			body.y = 50;
			body.graphics.beginFill(0,1);
			body.graphics.drawCircle(0,0,5);
			body.graphics.endFill();
			addChild(body);
			
			item = new SpinGravitationItem(body);
			
			target = new Shape();
			addChild(target);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			item.start(target);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			target.x = this.mouseX;
			target.y = this.mouseY;
		}
	}
}