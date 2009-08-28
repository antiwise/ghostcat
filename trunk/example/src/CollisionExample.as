package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import org.ghostcat.display.viewport.CollisionSprite;
	import org.ghostcat.display.GBase;
	import org.ghostcat.util.DisplayUtil;
	import org.ghostcat.util.Geom;
	
	
	[SWF(width="520",height="400",frameRate="30")]
	/**
	 * 这个类是为了演示不规则碰撞区域的。由于并不是位图碰撞，碰撞区域可以设定得很复杂，面积也可以很大。
	 * 而且不会因为位图的像素问题使得碰撞不平滑,也不会因为滤镜等因素使得碰撞区域变化。
	 * 
	 * 这种方法可以准确地找到碰撞边缘。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class CollisionExample extends Sprite
	{
		public var b:CollisionSprite;
		
		public var point:GBase;
			
		public function CollisionExample()
		{
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		private function init(event:Event):void
		{
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
		
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		public function enterFrameHandler(event:Event):void
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