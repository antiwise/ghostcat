package
{
	import flash.display.Sprite;
	
	import org.ghostcat.skin.cursor.ScrollUpButton;
	import org.ghostcat.ui.controls.GButton;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			addChild(new GButton(new ScrollUpButton()))
		}
	}
}