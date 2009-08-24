package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.ghostcat.algorithm.bezier.Roupe;
	import org.ghostcat.display.graphics.DragPoint;
	import org.ghostcat.manager.RootManager;
	import org.ghostcat.ui.CursorSprite;
	import org.ghostcat.ui.ToolTipSprite;
	
	public class SmoothCurveExample extends Sprite
	{
		private var roupe:Roupe;
		
		private var start:DragPoint = new DragPoint();
		private var end:DragPoint = new DragPoint();
		
		public function SmoothCurveExample()
		{
			RootManager.register(this,1,1);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			initControl(start,"起点");
			initControl(end,"终点");
			roupe = new Roupe(start.point, end.point,10);
			
			stage.addChild(new CursorSprite());
			stage.addChild(new ToolTipSprite())
		}
		
		private function initControl(pt:DragPoint, pointName:String = null):void 
		{
			pt.x = Math.random()*stage.stageWidth;
			pt.y = Math.random()*stage.stageHeight;
			pt.toolTip = pointName;
			addChild(pt);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			graphics.clear();
			graphics.lineStyle(0,0,1);
			roupe.applyPhysics();
			roupe.parse(this);
		}
	}
}