package 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import org.ghostcat.display.graphics.DragPoint;
	import org.ghostcat.display.viewport.Light;
	import org.ghostcat.display.viewport.Wall;
	import org.ghostcat.events.MoveEvent;
	import org.ghostcat.ui.CursorSprite;
	
	[SWF(width="500",height="400",backgroundColor="0x0")]
	public class LightExample extends Sprite
	{
		public var w:Wall;
		public function LightExample()
		{
			var p1:DragPoint = new DragPoint(new Point(0,100));
			var p2:DragPoint = new DragPoint(new Point(100,0));
			p1.addEventListener(MoveEvent.MOVE,moveHanlder);
			p2.addEventListener(MoveEvent.MOVE,moveHanlder);
			w = new Wall(new TestRepeater(),p1.point,p2.point,50);
			addChild(w);
			addChild(p1);
			addChild(p2);
			
			var r:Sprite = new TestRepeater45();
			r.scaleX = r.scaleY = 0.2;
			r.x = 200;
			r.y = 100;
			addChild(r);
			
			var l:Light = new Light(250);
			l.x = 300;
			l.y = 120;
			addChild(l);
			l.addItem(r);
			l.addWall(w);
		}
		private function moveHanlder(event:MoveEvent):void
		{
			w.invalidateDisplayList();
		}
	}
}