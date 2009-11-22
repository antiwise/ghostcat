package
{
	import flash.display.Sprite;
	
	import ghostcat.ui.controls.GColorPicker;

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
			addChild(new GColorPicker())
		}
	}
}