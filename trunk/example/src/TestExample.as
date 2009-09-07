package
{
	import flash.display.Sprite;
	
	import org.ghostcat.ui.controls.GRadioButton;
	import org.ghostcat.ui.controls.GRadioButtonGroup;
	
	[SWF(width="400",height="400")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{
			var b:GRadioButton = new GRadioButton();
			b.label = "123";
			b.groupName = "a";
			addChild(b);
			
			var b2:GRadioButton = new GRadioButton();
			b2.label = "456";
			b2.groupName = "a";
			b2.y = 20;
			addChild(b2);
			
			GRadioButtonGroup.getGroupByName("a").selectedItem = b;
		}
	}
}