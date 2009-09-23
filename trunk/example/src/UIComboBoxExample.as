package
{
	import flash.display.Sprite;
	
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.ui.controls.GComboBox;
	import ghostcat.ui.controls.GVSilder;
	import ghostcat.util.Util;
	
	[SWF(width="600",height="600")]
	public class UIComboBoxExample extends Sprite
	{
		public function UIComboBoxExample()
		{	
			var b:GComboBox = new GComboBox();
			b.data = 123;
			b.x = 100;
			b.listData = [222,343,554,343,554,343,554,343,554,343,554,343,554,343,554,343,554];
			addChild(b)
			
			var s:GVSilder = new GVSilder();
			addChild(s);
			
			addChild(Util.createObject(new ResidualScreen(20,100),{refreshInterval:30,fadeSpeed:0.8,blurSpeed:3,items:[s]}));
		}
	}
}