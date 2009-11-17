package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import ghostcat.display.GBase;
	import ghostcat.display.bitmap.BitmapScreen;
	import ghostcat.display.transfer.effect.MosaicHandler;
	
	
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public dynamic class TestExample extends GBase
	{
		protected override function init():void
		{
			var t:DisplayObject = new TestCollision();
			var s:BitmapScreen = new BitmapScreen(600,450);
			addChild(s);
			
			s.addChild(t);

		}
	}
}