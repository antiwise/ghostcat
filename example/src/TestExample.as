package
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	import ghostcat.skin.AlertSkin;
	import ghostcat.ui.controls.GEffectButton;

	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		
		protected override function init():void
		{
			var b:GEffectButton = new GEffectButton(new AlertSkin());
			addChild(b);
			
//			var b:Bitmap = new Bitmap(ScreenShotUtil.shotObject(t,new Rectangle(10,10,200,200)))
//			addChild(b);
//			t.alpha = 0.3;
		}
	}
}