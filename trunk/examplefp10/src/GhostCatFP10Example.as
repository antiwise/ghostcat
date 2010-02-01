package 
{
	import flash.text.TextField;
	
	import ghostcat.display.GBase;
	
	[SWF(width="200",height="200",backgroundColor="0xFFFFFF")]
	
	public class GhostCatFP10Example extends GBase
	{
		public function GhostCatFP10Example()
		{
			var t:TextField = new TextField();
			addChild(t);
			t.htmlText = encodeURIComponent("<html>123");
		}
	}
}