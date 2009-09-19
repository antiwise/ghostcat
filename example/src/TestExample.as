package
{
	import flash.display.Sprite;
	
	import ghostcat.util.URL;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			trace(new URL(loaderInfo.url));
		}
	}
}