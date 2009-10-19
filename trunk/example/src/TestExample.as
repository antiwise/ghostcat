package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Display45Util;
	
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
			Display45Util.setContentSize(100,50);
			
			var r:Array = Display45Util.divShape(v,true)
			
//			addChild(new Bitmap(r[0][0]))
				
			for (var j:int = 0;j < r.length;j++)
				for (var i:int = 0;i < r[j].length;i++)
				{
					v = new Bitmap(r[j][i] as BitmapData);
					v.x = i * 100;
					v.y = j * 100;
					addChild(v);
				}
			
		}
	}
}