package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ghostcat.skin.HScrollBarSkin;
	import ghostcat.transfer.Mosaic;
	import ghostcat.ui.controls.GNumberic;
	import ghostcat.ui.controls.GNumbericStepper;
	import ghostcat.util.TweenUtil;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:Mosaic = new Mosaic(new TestCollision());
			addChild(t);
		
			TweenUtil.to(t,10000,{mosaicSize:100})
		}
	}
}