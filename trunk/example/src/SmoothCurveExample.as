package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ghostcat.algorithm.bezier.Roupe;
	import ghostcat.display.GBase;
	import ghostcat.display.graphics.DragPoint;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.SmoothCurveTweenOper;
	import ghostcat.ui.CursorSprite;
	import ghostcat.ui.ToolTipSprite;
	import ghostcat.ui.tooltip.ArowToolTipSkin;
	
	/**
	 * 拥有重力的细绳
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SmoothCurveExample extends GBase
	{
		private var roupe:Roupe;
		
		private var start:DragPoint = new DragPoint();
		private var end:DragPoint = new DragPoint();
		
		public function SmoothCurveExample()
		{
			RootManager.register(this);
			
			initControl(start,"起点");
			initControl(end,"终点");
			roupe = new Roupe(start.position, end.position,10);
			roupe.physics.hasEnd = true;
			
			stage.addChild(new CursorSprite());
			stage.addChild(new ToolTipSprite());
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			
			this.enabledTick = true;
		}
		
		private function initControl(pt:DragPoint, pointName:String = null):void 
		{
			pt.x = Math.random()*stage.stageWidth;
			pt.y = Math.random()*stage.stageHeight;
			pt.toolTip = pointName;
			addChild(pt);
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			graphics.clear();
			graphics.lineStyle(0,0,1);
			roupe.applyPhysics(event.interval);
			roupe.parse(this);
			
			end.invalidatePosition();
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