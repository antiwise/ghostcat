package
{
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import ghostcat.display.DisplayUtil;
	import ghostcat.display.GBase;
	import ghostcat.display.GTickBase;
	import ghostcat.display.viewport.CollisionSprite;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.util.Geom;
	
	
	[SWF(width="520",height="400",frameRate="30")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	/**
	 * 这个类是为了演示不规则碰撞区域的。由于并不是位图碰撞，碰撞区域可以设定得很复杂，面积也可以很大。
	 * 而且不会因为位图的像素问题使得碰撞不平滑,也不会因为滤镜等因素使得碰撞区域变化。
	 * 
	 * 这种方法可以准确地找到碰撞边缘。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class CollisionExample extends GTickBase
	{
		public var b:CollisionSprite;
		
		public var point:GBase;
			
		protected override function init():void
		{
			RootManager.register(this);
			
			b = new CollisionSprite(new TestCollision())
			Geom.centerIn(b,stage);
			addChild(b);
			
			var s:Shape = new Shape();
			s.graphics.beginFill(0);
			s.graphics.drawCircle(0,0,3);
			s.graphics.endFill();
			point = new GBase(s);
			DisplayUtil.setMouseEnabled(point,false);
			
			addChild(point);
			
			GAlert.show("这是一个碰撞示例程序，小球会跟踪鼠标移动，尽可能贴在图形的边缘\n中间的红圈是强制可通行区域","说明")
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			point.x = mouseX;
			point.y = mouseY;
			
			if (b.collision.hitTestPoint(new Point(mouseX,mouseY),point.oldPosition))
			{
				b.filters = [new GlowFilter(0xFFFFFF,1,30,30)];
				point.position = b.collision.lastVergePoint;
			}
			else
				b.filters = [];
		}
	}
}