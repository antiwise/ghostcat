package 
{
	import flash.display.Sprite;
	
	import org.ghostcat.extend.IFrame;

	[SWF(width="500",height="400")]
	public class IFrameExample extends Sprite
	{
		public var iframe:IFrame;
		public function IFrameExample()
		{
			iframe = new IFrame("iframe1");
			iframe.y = 25;
			iframe.width = 500;
			iframe.height = 350;
			iframe.url = "http://www.google.com";
		}
	}
}