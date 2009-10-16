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
			v.enabledTileY = false;
			addChild(v);
			v.autoMove = new Point(100,0);
			v.addLayer(TestHuman,2,new Point(0,100),true);
//			v.addLayer(TestRepeater,1,null,true);
		}

	}
}