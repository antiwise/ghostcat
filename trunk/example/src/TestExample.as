package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.ghostcat.ui.controls.GHScrollBar;
	import org.ghostcat.ui.controls.GVScrollBar;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:Sprite = new TestCollision();
			addChild(t);

			var s:GVScrollBar = new GVScrollBar();
			s.x = 200;
			s.target = t;
			s.setTargetScrollRect(new Rectangle(0,0,100,100))
			addChild(s);
		}
	}
}