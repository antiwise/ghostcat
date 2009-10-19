package
{
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Divide45Util;
	
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
			var v:DisplayObject = new TileObj();
			
			var r:Array = Divide45Util.divShape(v,false,100,50);
				
			for (var j:int = 0;j < r.length;j++)
				for (var i:int = 0;i < r[j].length;i++)
				{
					v = r[j][i] as DisplayObject;
					v.x = i * 100;
					v.y = j * 100;
					addChild(v);
				}
			
		}
	}
}