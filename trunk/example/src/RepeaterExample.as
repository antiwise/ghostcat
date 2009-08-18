package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.display.GRepeater;
	import org.ghostcat.events.RepeatEvent;
	import org.ghostcat.manager.DragManager;
	import org.ghostcat.manager.RootManager;
	import org.ghostcat.parse.DisplayParse;
	import org.ghostcat.parse.graphics.GraphicsLineStyle;
	import org.ghostcat.parse.graphics.GraphicsRect;

	/**
	 * 这个类生成了一个100000 x 100000的重复区域，但Repeater类的实际体积其实只有屏幕大小，因此并不消耗资源
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class RepeaterExample extends Sprite
	{
		public var repeater:GRepeater;
		public function RepeaterExample()
		{
			RootManager.register(this,1,1);
			repeater = new GRepeater(TestRepeater);
			repeater.width = 100000;
			repeater.height = 100000;
			repeater.viewRect = new Rectangle(0,0,500,500);
			repeater.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			repeater.addEventListener(RepeatEvent.ADD_REPEAT_ITEM,addRepeatItemHandler);
			
			addChild(repeater);
			addChild(DisplayParse.createShape([new GraphicsLineStyle(0,0xFF0000),new GraphicsRect(0,0,500,500)]));
		}
		private function mouseDownHandler(event:MouseEvent):void
		{
			DragManager.startDrag(repeater);
			trace(repeater.getItemPointAtPoint(new Point(repeater.mouseX,repeater.mouseY)))
		}
		private function addRepeatItemHandler(event:RepeatEvent):void
		{
			(event.repeatObj as TestRepeater).point.text = event.repeatPos.toString();
		}
	}
}