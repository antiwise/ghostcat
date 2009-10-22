package
{
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	import ghostcat.display.GBase;
	import ghostcat.display.transition.TransitionDisplayLayer;
	import ghostcat.display.transition.TransitionLayer;
	import ghostcat.display.viewport.BackgroundLayer;
	import ghostcat.ui.controls.GBitmapText;
	import ghostcat.util.core.Handler;
	import ghostcat.util.easing.Circ;
	
	[SWF(width="600",height="600")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public function TestExample()
		{
			var t:GBitmapText = new GBitmapText();
			t.text = "测 试文 字";
			t.setTextFormat(new TextFormat(null,null,0xFFFFFF),2,4);
			t.applyFilter(new GlowFilter(0x0,1,2,2,100),2,4);
			addChild(t);
		}
		
		private function f():void
		{
			TransitionLayer.continueFadeOut();
		}
	}
}