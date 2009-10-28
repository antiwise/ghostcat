package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import ghostcat.display.GBase;
	import ghostcat.util.display.BitmapUtil;

	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		[Embed(source="p1.jpg")]
		public var p1:Class;
		[Embed(source="p2.jpg")]
		public var p2:Class;
		
		public var bitmap:Bitmap = new p1();
		
		public function TestExample()
		{
			var bd:BitmapData = bitmap.bitmapData;
			addChild(new Bitmap(BitmapUtil.getTransparentBitmapData(bd)));
		}
	}
}