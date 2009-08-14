package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.ghostcat.debug.DebugScreen;
	import org.ghostcat.display.GRepeater45;
	import org.ghostcat.events.RepeatEvent;
	import org.ghostcat.manager.DragManager;
	import org.ghostcat.manager.RootManager;

	/**
	 * 这个类生成了一个100000 x 100000的重复区域，但Repeater类的实际体积其实只有屏幕大小，因此并不消耗资源
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class Repeater45Example extends Sprite
	{
		public var repeater:GRepeater45;
		public function Repeater45Example()
		{
			RootManager.register(this,1,1);
			repeater = new GRepeater45(TestRepeater,true);
			repeater.width = 100000;
			repeater.height = 100000;
			repeater.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			repeater.addEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			addChild(repeater);
		}
		private function mouseDownHandler(event:MouseEvent):void
		{
			DragManager.startDrag(repeater);
		}
		private function addRepeatItemHandler(event:RepeatEvent):void
		{
			(event.repeatObj as TestRepeater).point.text = event.repeatPos.toString();
		}
	}
}