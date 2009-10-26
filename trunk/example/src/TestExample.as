package
{
	import flash.display.Bitmap;
	
	import ghostcat.display.GBase;
	import ghostcat.display.transition.TransitionTransferLayer2;
	import ghostcat.transfer.MosaicTransfer;
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
		[Embed(source="back.jpg")]
		public var ref:Class;
		
		public var t:TransitionTransferLayer2;
		public var s:Bitmap;
		public function TestExample()
		{
			s = new ref();
			addChild(s);
			
			t = new TransitionTransferLayer2(new Handler(f),MosaicTransfer,s,500,500,false,Circ.easeIn,Circ.easeOut);
			t.createTo(this);
		}
		
		public function f():void
		{
			s.bitmapData.noise(0);
		}
	}
}