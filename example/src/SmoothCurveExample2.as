package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.algorithm.bezier.SmoothCurve;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.graphics.DragPoint;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.CursorSprite;
	
	/**
	 * 过点曲线
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SmoothCurveExample2 extends Sprite
	{
		private var roupe:SmoothCurve;
		
		private var start:DragPoint = new DragPoint();
		private var p1:DragPoint = new DragPoint();
		private var p2:DragPoint = new DragPoint();
		private var p3:DragPoint = new DragPoint();
		private var end:DragPoint = new DragPoint();
		
		public function SmoothCurveExample2()
		{
			new EnabledSWFScreen(stage);
			
			RootManager.register(this);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			start.position = new Point(0,100);
			addChild(start);
			p1.position = new Point(50,100);
			addChild(p1);
			p2.position = new Point(100,100);
			addChild(p2);
			p3.position = new Point(150,100);
			addChild(p3);
			end.position = new Point(200,100);
			addChild(end);
			roupe = new SmoothCurve(true);
			roupe.createFromPath([start.position,p1.position,p2.position,p3.position,end.position]);
			
			stage.addChild(new CursorSprite());
		}
		
		private function enterFrameHandler(event:Event):void
		{
			graphics.clear();
			graphics.lineStyle(0,0,1);
			roupe.parse(this);
		}
	}
}