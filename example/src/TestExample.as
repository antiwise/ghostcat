package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ghostcat.manager.DragManager;
	import ghostcat.skin.cursor.CursorArow;
	import ghostcat.ui.CursorSprite;
	import ghostcat.util.TweenUtil;
	import ghostcat.util.easing.Elastic;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:Sprite = new TestCollision();
			addChild(t);
			t.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
			var s:CursorSprite = new CursorSprite();
			addChild(s);
			s.setCursor(CursorArow)
			
			TweenUtil.to(t,10000,{dynamicPoint:s,ease: ghostcat.util.easing.Elastic.easeOut})
			
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			DragManager.startDrag(event.currentTarget as DisplayObject);
		}
	}
}