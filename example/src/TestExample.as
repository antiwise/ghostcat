package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import ghostcat.ui.controls.GColorPicker;
	import ghostcat.util.data.ConversionUtil;
	import ghostcat.util.display.PaletteUtil;

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
			var a:Array = [["x","y"],[1,2],[1,2]];
			a = ConversionUtil.filterArray(a,["x"]);
		}
	}
}