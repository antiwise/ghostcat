package
{
	import ghostcat.display.GBase;
	import ghostcat.text.StringCompareUtil;

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
			var a:Array = StringCompareUtil.compare("特殊的事情","并不特殊的问题");
			trace(a);
			trace(StringCompareUtil.apply("特殊的事情",a))
		}
	}
}