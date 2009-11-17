package
{
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import ghostcat.debug.DebugScreen;
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.CollisionSprite;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.EllipseParse;
	import ghostcat.parse.graphics.GraphicsEllipse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.display.Geom;
	import ghostcat.util.display.HitTest;
	
	
	[SWF(width="520",height="400",frameRate="30")]
	public class HitTestExample extends GBase
	{
		public var b:CollisionSprite;
		
		public var point:GBase;
			
		protected override function init():void
		{
			RootManager.register(this);
			
			//建立一个支持检测碰撞的图元
			b = new CollisionSprite(new TestCollision())
			Geom.centerIn(b,stage);
			addChild(b);
			
			//建立一个点
			point = new GBase(new TestHuman());
			addChild(point);
			
			DisplayUtil.setMouseEnabled(point,false);
			
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			//控制点到达鼠标处
			point.x = mouseX;
			point.y = mouseY;
			
			//检测碰撞，并将点的位置重新设置在碰撞处
			if (HitTest.complexHitTestObject(b,point))
			{
				b.alpha = 0.5;
			}
			else
				b.alpha = 1.0;
		}
	}
}