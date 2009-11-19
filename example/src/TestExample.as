package
{
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			flash.net.navigateToURL(new URLRequest("http://www.google.com"),"_self");
		}
	}
}