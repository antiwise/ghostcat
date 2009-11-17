package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import ghostcat.display.GBase;
	import ghostcat.display.bitmap.BitmapScreen;
	import ghostcat.display.bitmap.BitmapZoomScreen;
	import ghostcat.display.transfer.effect.MosaicHandler;
	import ghostcat.skin.AlertSkin;
	import ghostcat.text.TextTweenUtil;
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
			var t:TextField = new TextField();
			t.htmlText = "<font color='#FFFFF'>1<b>2</b>3</font>4"
			addChild(t);
			
			TextTweenUtil.tweenQuick(t,1000);
		}
	}
}