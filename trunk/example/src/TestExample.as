package
{
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import ghostcat.display.GBase;
	import ghostcat.text.GradientText;
	import ghostcat.ui.containers.GScrollPanel;
	import ghostcat.ui.html.SimpleHTML;

	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		
		protected override function init():void
		{
			super.init();
			navigateToURL(new URLRequest("www.google.com"));
		}
	}
}