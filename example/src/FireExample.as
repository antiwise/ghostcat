package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.ghostcat.bitmap.effect.FireScreen;
	import org.ghostcat.display.GBase;
	import org.ghostcat.manager.DragManager;
	import org.ghostcat.skin.cursor.CursorDrag;
	import org.ghostcat.ui.CursorSprite;
	
	[SWF(width="300",height="300")]
	public class FireExample extends Sprite
	{
		public var p:GBase;
		public function FireExample()
		{
			p = new GBase(new TestHuman());
			p.cursor = CursorDrag;
			p.x = 150;
			p.y = 100
			addChild(p);
			p.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
			var f:FireScreen = new FireScreen(300,300);
			f.addItem(p);
			addChildAt(f,0);
			
			stage.addChild(new CursorSprite());
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			DragManager.startDrag(p);
		}
	}
}