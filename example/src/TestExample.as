package
{
	import flash.display.Sprite;
	
	import org.ghostcat.util.Guid;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			var v:Guid = new Guid();
			trace(v.toString())
		}
	}
}