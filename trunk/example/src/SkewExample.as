package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.ghostcat.display.graphics.DragPoint;
	import org.ghostcat.transfer.Skew;
	import org.ghostcat.ui.CursorSprite;
	
	[SWF(width="300",height="300")]
	public class SkewExample extends Sprite
	{
		public var f:Skew;
		public var p1:DragPoint = new DragPoint(new Point(50,10));
		public var p2:DragPoint = new DragPoint(new Point(150,50));
		public var p3:DragPoint = new DragPoint(new Point(40,240));
		public var p4:DragPoint = new DragPoint(new Point(260,150));
		public function SkewExample()
		{
			f = new Skew(new TestCollision(),10,10);
			addChild(f);
			
			addChild(p1);
			addChild(p2);
			addChild(p3);
			addChild(p4);
			
			f.setTransform(p1.point,p2.point,p3.point,p4.point);
			
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			
			stage.addChild(new CursorSprite());
		}
		
		private function enterFrameHandler(event:Event):void
		{
			f.invalidateTransform();
		}
	}
}