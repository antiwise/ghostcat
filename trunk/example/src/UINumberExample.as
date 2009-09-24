package
{
	import flash.display.Sprite;
	
	import ghostcat.skin.HScrollBarSkin;
	import ghostcat.ui.controls.GNumberic;
	import ghostcat.ui.controls.GNumbericStepper;
	
	[SWF(width="600",height="600")]
	/**
	 * 数字输入框
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class UINumberExample extends Sprite
	{
		public function UINumberExample()
		{	
			var t:GNumbericStepper = new GNumbericStepper();
			t.prefix = "$";
			t.setValue(100);
			t.editable = true;
			t.autoSelect = true;
			addChild(t);
		}
	}
}