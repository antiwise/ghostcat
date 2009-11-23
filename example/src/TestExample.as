package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import ghostcat.ui.controls.GColorPicker;
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
			addChild(new Bitmap(PaletteUtil.getLightPaletter(0xFF0000)))
		}
	}
}