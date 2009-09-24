package 
{
	import flash.display.Sprite;
	
	import ghostcat.display.graphics.ControlRect;
	import ghostcat.ui.CursorSprite;
	
	[SWF(width="300",height="300")]
	/**
	 * 图形变换例子
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ControlRectExample extends Sprite
	{
		public function ControlRectExample()
		{
			addChild(new ControlRect(new TestRepeater()))
			addChild(new ControlRect(new TestRepeater45()))
			addChild(new CursorSprite())
		}
	}
}