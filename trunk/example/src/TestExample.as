package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.display.transition.TransitionCacheTransferLayer;
	import ghostcat.transfer.MosaicTransfer;
	import ghostcat.util.core.Handler;
	
	[SWF(width="600",height="600")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		[Embed(source="back.jpg")]
		public var ref:Class;
		
		public var t:TransitionCacheTransferLayer;
		public function TestExample()
		{
			var s:DisplayObject = new ref();
			addChild(s);
			
			t = new TransitionCacheTransferLayer(new Handler(f),new MosaicTransfer(s));
			t.createTo(this);
		}
		
		public function f():void
		{
			(t.transfer.target as Bitmap).bitmapData.noise(0);
		}
	}
}