package
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.ghostcat.display.viewport.Light;
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.parse.graphics.GraphicsLineStyle;
	import org.ghostcat.parse.graphics.GraphicsRect;
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
			p2.x = 50;
			p2.y = 25;
		}
		
	}
}