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
	import ghostcat.util.display.ColorConvertUtil;
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
			trace(ColorConvertUtil.toHSL(0xFF0000).toString(16));
		}
	}
}