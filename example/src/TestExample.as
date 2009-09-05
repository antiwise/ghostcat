package
{
	import flash.display.Sprite;
	
	import org.ghostcat.skin.HScrollThumbSkin;
	import org.ghostcat.ui.controls.GButton;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			addChild(new GButton(new HScrollThumbSkin()))
		}
	}
}