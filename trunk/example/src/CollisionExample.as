package
{
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import ghostcat.debug.DebugScreen;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GBase;
	import ghostcat.display.game.CollisionSprite;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.parse.display.EllipseParse;
	import ghostcat.parse.graphics.GraphicsEllipse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.display.Geom;
	
	
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
	
	public class CollisionExample extends GBase
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
			point = new GBase(new EllipseParse(new GraphicsEllipse(0,0,6,6),null,new GraphicsFill(0)).createShape());
			addChild(point);
			
			DisplayUtil.setMouseEnabled(point,false);
			
			GAlert.show("这是一个碰撞示例程序，小球会跟踪鼠标移动，尽可能贴在图形的边缘\n中间的红圈是强制可通行区域","说明")
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			//控制点到达鼠标处
			point.x = mouseX;
			point.y = mouseY;
			
			//检测碰撞，并将点的位置重新设置在碰撞处
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