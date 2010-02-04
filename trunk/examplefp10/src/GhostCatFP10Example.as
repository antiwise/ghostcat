package 
{
	import flash.display.Bitmap;
	
	import ghostcat.display.GBase;
	import ghostcat.display.transfer.BookTransfer;
	import ghostcat.util.easing.Bounce;
	import ghostcat.util.easing.TweenUtil;

	[SWF(width="1000",height="1000")]
	public class GhostCatFP10Example extends GBase
	{
		[Embed(source="p5.jpg")]
		public var cls:Class;
		public var be:BookTransfer;
		public function GhostCatFP10Example()
		{
			var bitmap:Bitmap = new cls();
			be = new BookTransfer(bitmap);
			addChild(be);
			
			be.x = 200;
			be.y = 20;
			TweenUtil.from(be,500,{y:-300,ease:Bounce.easeIn})
			
//			TweenUtil.from(be,1000,{point:new Point(200,1000),alpha:0.0,ease:Circ.easeIn})
			
		}
	}
}