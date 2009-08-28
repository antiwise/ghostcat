package
{
	import flash.display.Sprite;
	
	import org.ghostcat.util.Hash;
	import org.ghostcat.util.RandomUtil;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			while (true)
			{
				var s:String = RandomUtil.string(16);
				trace(Hash.fromString(s,0,true));
			}
		}
	}
}