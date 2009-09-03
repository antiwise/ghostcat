package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.ghostcat.display.GBase;
	import org.ghostcat.display.graphics.DragPoint;
	import org.ghostcat.display.viewport.Light;
	import org.ghostcat.display.viewport.Wall;
	import org.ghostcat.events.MoveEvent;
	import org.ghostcat.manager.DragManager;
	import org.ghostcat.skin.cursor.CursorDrag;
	import org.ghostcat.ui.CursorSprite;
	import org.ghostcat.util.Util;
	
	[SWF(width="500",height="400")]
	public class LightExample extends Sprite
	{
		public var w:Wall;
		public var l1:Light;
		public var l2:Light;
		public var r:GBase;
		public function LightExample()
		{
			var p1:DragPoint = new DragPoint(new Point(100,200));
			var p2:DragPoint = new DragPoint(new Point(200,100));
			p1.addEventListener(MoveEvent.MOVE,moveHanlder);
			p2.addEventListener(MoveEvent.MOVE,moveHanlder);
			
			w = new Wall(new TestRepeater(),p1.point,p2.point,100);
			addChild(w);
			addChild(p1);
			addChild(p2);
			
			l1 = Util.createObject(new Light(250),{refreshInterval:33,x:300,y:120,color:0xFF0000});
			addChild(l1);
			l2 = Util.createObject(new Light(250),{refreshInterval:33,x:420,y:300,color:0x0000FF});
			addChild(l2);
			
			r = Util.createObject(new GBase(new TestHuman()),{cursor:CursorDrag,x:250,y:150});
			addChild(r);
			
			l1.addItem(r);
			l2.addItem(r);
			l1.addWall(w);
			l2.addWall(w);
			
			r.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
			stage.addChild(new CursorSprite())
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			DragManager.startDrag(r);
		}
		private function moveHanlder(event:MoveEvent):void
		{
			w.invalidateDisplayList();
		}
	}
}