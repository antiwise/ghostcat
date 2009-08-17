package
{
	import flash.display.Sprite;
	
	import org.ghostcat.display.viewport.Light;
	import org.ghostcat.util.HitTest;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public var p:Light;
		public function TestExample()
		{
			var p1:Sprite = new TestRepeater();
			addChild(p1);
			var p2:Sprite = new TestRepeater45();
			addChild(p2);
			
			trace(HitTest.intersectionRectangle(p1,p2))
			trace(p1.getBounds(stage).intersection(p2.getBounds(stage)))
		}
		
	}
}