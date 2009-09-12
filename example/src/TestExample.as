package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import ghostcat.ui.containers.ScrollPanel;
	import ghostcat.ui.controls.GVScrollBar;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:Sprite = new TestCollision();
			addChild(t);
			
			var s:ScrollPanel = new ScrollPanel(t,new Rectangle(0,0,100,100));
			addChild(s);
			s.addHScrollBar();
			s.addVScrollBar();
			
		}
	}
}