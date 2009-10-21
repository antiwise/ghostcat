package
{
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.display.transition.TransitionDisplayLayer;
	import ghostcat.display.transition.TransitionLayer;
	import ghostcat.display.viewport.BackgroundLayer;
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
			var t:BackgroundLayer = new BackgroundLayer(600,600);
			t.addLayer(TestRepeater,1,null,true);
			t.autoMove = new Point(50,50);
			
			new TransitionDisplayLayer(new Handler(f),t,1000,1000,true,Circ.easeIn,Circ.easeIn).createTo(this);
		}
		
		private function f():void
		{
			TransitionLayer.continueFadeOut();
		}
	}
}