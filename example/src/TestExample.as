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
	import ghostcat.display.bitmap.BitmapZoomScreen;
	import ghostcat.display.transfer.effect.MosaicHandler;
	import ghostcat.skin.AlertSkin;
	import ghostcat.util.Util;
	import ghostcat.util.easing.TweenUtil;
	
	
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
			var t:Sprite = new Sprite();
			t.addChild(Util.createObject(new AlertSkin(),{x:300,y:225}));
			var s:BitmapZoomScreen = new BitmapZoomScreen(t,600,450);
			s.accuracy = 1.0;
			addChild(s);
			
			TweenUtil.to(s,1000,{zoom:2})

		}
	}
}