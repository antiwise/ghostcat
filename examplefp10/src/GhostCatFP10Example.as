package 
{
	import flash.display.Bitmap;
	
	import ghostcat.display.GBase;
	import ghostcat.display.transfer.BookTransfer;
	import ghostcat.display.transfer.PixelShowTransfer;
	import ghostcat.operation.effect.PushEffect;
	import ghostcat.ui.UIConst;
	import ghostcat.util.easing.Bounce;
	import ghostcat.util.easing.Circ;
	import ghostcat.util.easing.TweenUtil;

	[SWF(width="1000",height="1000")]
	public class GhostCatFP10Example extends GBase
	{
		[Embed(source="p5.jpg")]
		public var cls:Class;
		public var be:PixelShowTransfer;
		public function GhostCatFP10Example()
		{
			var bitmap:Bitmap = new cls();
			be = new PixelShowTransfer(bitmap);
			addChild(be);
			
			new PushEffect(be,1000,"right",Circ.easeOut).execute();
			
			be.step = 0.0;
			TweenUtil.to(be,1000,{step:1.0});
			
		}
	}
}