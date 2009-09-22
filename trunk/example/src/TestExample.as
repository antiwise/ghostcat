package
{
	import flash.display.Sprite;
	
	import ghostcat.ui.controls.GComboBox;
	import ghostcat.ui.controls.GVSilder;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var b:GComboBox = new GComboBox();
			b.data = 123;
			b.x = 100;
			b.listData = [222,343,554,343,554,343,554,343,554,343,554,343,554,343,554,343,554];
			addChild(b)
			
			var s:GVSilder = new GVSilder();
			addChild(s);
		}
	}
}