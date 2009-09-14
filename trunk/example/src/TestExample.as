package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ghostcat.manager.DragManager;
	import ghostcat.skin.cursor.CursorArow;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.controls.GImage;
	import ghostcat.util.TweenUtil;
	import ghostcat.util.easing.Elastic;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:Sprite = new TestCollision();
			addChild(t);
			
			var s:GImage = new GImage(t);
			s.width = 400;
			s.height = 100;
			addChild(s);
			
		}
	}
}