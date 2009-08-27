package
{
	import flash.display.Sprite;
	
	import org.ghostcat.text.ANSI;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			trace(ANSI.getLength("123特"));
		}
	}
}