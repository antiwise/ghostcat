package 
{
	import flash.display.Bitmap;
	import flash.utils.setTimeout;
	
	import ghostcat.display.GBase;
	import ghostcat.display.transfer.BookTransfer;
	import ghostcat.display.transfer.PixelShowTransfer;
	import ghostcat.manager.RootManager;
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
		protected override function init():void
		{
			RootManager.register(this);
			
			var bitmap:Bitmap = new cls();
			be = new PixelShowTransfer(bitmap);
			addChild(be);
			
			new PushEffect(be,1000,"left",Bounce.easeOut,true).execute();
			
			be.step = 0.0;
			TweenUtil.to(be,1000,{step:1.0});
		}
	}
}