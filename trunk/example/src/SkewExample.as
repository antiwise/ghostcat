package 
{
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.display.graphics.DragPoint;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.events.TickEvent;
	import ghostcat.transfer.Skew;
	import ghostcat.ui.CursorSprite;
	import ghostcat.util.Util;
	
	[SWF(width="300",height="300")]
	/**
	 * 自由变化例子
	 * 
	 * 顺带加了特效
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SkewExample extends GBase
	{
		public var f:Skew;
		public var p1:DragPoint = new DragPoint(new Point(50,10));
		public var p2:DragPoint = new DragPoint(new Point(150,50));
		public var p3:DragPoint = new DragPoint(new Point(40,240));
		public var p4:DragPoint = new DragPoint(new Point(260,150));
		protected override function init():void
		{
			f = new Skew(new TestCollision(),10,10);
			addChild(f);
			
			addChild(Util.createObject(new ResidualScreen(300,300),{enabledTick:true,fadeSpeed:0.9,blurSpeed:12,offest:new Point(0,-4),items:[f]}));
			
			addChild(p1);
			addChild(p2);
			addChild(p3);
			addChild(p4);
			
			f.setTransform(p1.point,p2.point,p3.point,p4.point);
			
			stage.addChild(new CursorSprite());
			
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			f.invalidateTransform();
		}
	}
}