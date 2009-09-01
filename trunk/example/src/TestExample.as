package
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	import org.ghostcat.display.loader.StreamTextLoader;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			var t:StreamTextLoader = new StreamTextLoader(new URLRequest("test.txt"));
			addChild(t);
			
		}
	}
}