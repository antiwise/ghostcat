package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.display.screenshot.ScreenShotPanel;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.ToolTipSprite;
	import ghostcat.util.easing.Back;
	import ghostcat.util.easing.TweenUtil;

	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		
		protected override function init():void
		{
			var v:DisplayObject = new TestCollision();
			addChild(v);
			
			TweenUtil.to(v,1000,{motionBlur:new Point(300,0),ease:Back.easeOut,invert:true});
			
		}
		
		private function r(b:BitmapData):void
		{
			addChild(new Bitmap(b));
			
		}
	}
}