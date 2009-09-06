package
{
	import flash.display.Sprite;
	
	import org.ghostcat.ui.controls.GRadioButton;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			var b:GRadioButton = new GRadioButton();
			b.label = "123";
			addChild(b);
		}
	}
}