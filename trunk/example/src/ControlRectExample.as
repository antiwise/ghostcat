package 
{
	import flash.display.Sprite;
	
	import org.ghostcat.display.graphics.ControlRect;
	import org.ghostcat.ui.CursorSprite;
	
	[SWF(width="300",height="300")]
	public class ControlRectExample extends Sprite
	{
		public function ControlRectExample()
		{
			addChild(new ControlRect(new TestRepeater()))
			addChild(new CursorSprite())
		}
	}
}