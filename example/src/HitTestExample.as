package
{
	import flash.geom.Point;
	
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GBase;
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.display.Geom;
	import ghostcat.util.collision.HitTest;
	
	
	[SWF(width="520",height="400",frameRate="30")]
	public class HitTestExample extends GBase
	{
		public var b:GBitmap;
		public var point:GBase;
			
		protected override function init():void
		{
			new EnabledSWFScreen(stage);
			
			RootManager.register(this);
			
			//建立一个支持检测碰撞的图元
			b = new GBitmap(new TestCollision())
			Geom.centerIn(b,stage);
			addChild(b);
			
			//建立一个点
			point = new GBase(new TestHuman());
			addChild(point);
			point.scaleX = 2;
			
			DisplayUtil.setMouseEnabled(point,false);
			
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			point.x = mouseX;
			point.y = mouseY;
			
			if (HitTest.complexHitTestObject(b,point))
				b.alpha = 0.5;
			else
				b.alpha = 1.0;
		}
	}
}