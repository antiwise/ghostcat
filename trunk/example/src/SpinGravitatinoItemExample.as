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
	import ghostcat.filter.ColorMatrixFilterProxy;
	
	[SWF(width = "500",height = "400")]
	public class SpinGravitatinoItemExample extends Sprite
	{
		public var target:Shape;
		public function SpinGravitatinoItemExample()
		{
			for (var i:int = 0;i < 50;i++)
				createRandomItem();
			
			target = new Shape();
			target.x = -1000;
			addChild(target);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		}
		
		private function createRandomItem():void
		{
			var body:Shape = new Shape();
			body.x = Math.random() * 500;
			body.y = Math.random() * 400;
			body.graphics.beginFill(0,1);
			body.graphics.drawCircle(0,0,5);
			body.graphics.endFill();
			addChild(body);
			
			var item:SpinGravitationItem = new SpinGravitationItem(body);	
			addEventListener(Event.ENTER_FRAME,tickHandler);
			item.addEventListener(Event.COMPLETE,completeHandler);
		
			function tickHandler(event:Event):void
			{
				if (new Point(body.x - target.x,body.y - target.y).length < 100)
				{
					removeEventListener(Event.ENTER_FRAME,tickHandler);
					
					item.start(target);
				}
			}
			
			
			function completeHandler(event:Event):void
			{
				item.removeEventListener(Event.COMPLETE,completeHandler);
				
				removeChild(body);
				createRandomItem();
			}
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			target.x = this.mouseX;
			target.y = this.mouseY;
		}
	}
}