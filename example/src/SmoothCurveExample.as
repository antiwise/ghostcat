package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.algorithm.bezier.Roupe;
	import ghostcat.debug.DebugRect;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GBase;
	import ghostcat.display.graphics.DragPoint;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.SmoothCurveTweenOper;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.ToolTipSprite;
	
	/**
	 * 拥有重力的细绳
	 * 
	 * @author flashyiyi
	 * 
	 */
	[SWF(width="500",height="400")]
	public class SmoothCurveExample extends GBase
	{
		private var roupe:Roupe;
		
		private var start:DragPoint = new DragPoint();
		private var end:DragPoint = new DragPoint();
		
		public function SmoothCurveExample()
		{
			RootManager.register(this);
			
			start.toolTip = "起点XXXX";
			start.position = new Point(50,50);
			addChild(start);
			
			end.toolTip = "终点";
			end.position = new Point(50,50);
			addChild(end);
			
			roupe = new Roupe(start.position, end.position,10,0.3,0.85,null,true);
			
			stage.addChild(new CursorSprite());
			stage.addChild(new ToolTipSprite());
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
			this.enabledTick = true;
		}
		
		private function initControl(pt:DragPoint, pointName:String = null):void 
		{
			pt.toolTip = pointName;
			addChild(pt);
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			graphics.clear();
			graphics.lineStyle(0,0x0,1);
			roupe.parse(this);
			
			end.vaildPosition();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			var p:Sprite = new TestHuman();
			addChild(p);
			new SmoothCurveTweenOper(p,roupe,1000,{onComplete:completeHandler}).execute();
			
			function completeHandler():void
			{
				removeChild(p);
			}
		}
	}
}