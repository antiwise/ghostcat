package
{
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.BackgroundLayer;
	

	
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
			var v:BackgroundLayer = new BackgroundLayer(600,600);
			addChild(v);
			v.autoMove = new Point(100,100);
			v.addLayer(TestRepeater,2,true);
			v.addLayer(TestHuman,1,true);
		}

	}
}