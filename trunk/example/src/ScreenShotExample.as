package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import ghostcat.display.GBase;
	import ghostcat.display.screenshot.ScreenShotPanel;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.ToolTipSprite;

	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ScreenShotExample extends GBase
	{
		
		protected override function init():void
		{
			var b:DisplayObject = new TestCollision();
			addChild(b);
			
			new ScreenShotPanel(r,stage);
			
			stage.addChild(new CursorSprite());
			stage.addChild(new ToolTipSprite());
			
		}
		
		private function r(b:BitmapData):void
		{
			addChild(new Bitmap(b));
			
		}
	}
}