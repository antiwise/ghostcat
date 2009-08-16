package
{
	import flash.display.Sprite;
	
	import org.ghostcat.display.viewport.Light;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public var p:Light;
		public function TestExample()
		{
			p = new Light(50);
			p.x = 50;
			p.y = 50;
			addChild(p);
		}
		
	}
}