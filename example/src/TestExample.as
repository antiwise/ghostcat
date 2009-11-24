package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ghostcat.display.transfer.Ripple;
	import ghostcat.ui.controls.GColorPicker;
	import ghostcat.util.data.ConversionUtil;
	import ghostcat.util.display.PaletteUtil;

	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends Sprite
	{
		public var r:Ripple;
		public function TestExample()
		{
			var b:DisplayObject = new TestCollision();
			b.x = 200;
			b.y = 200;
			addChild(b);
			
			r = new Ripple(b,true,40,6);
			
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			r.drawRipple(r.mouseX,r.mouseY,15);
		}
	}
}