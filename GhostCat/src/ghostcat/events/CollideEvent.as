package ghostcat.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import ghostcat.display.viewport.ICollisionClient;
	
	/**
	 * 碰撞事件
	 * @author flashyiyi
	 * 
	 */
	public class CollideEvent extends Event
	{
		public static const COLLIDE:String = "collide";
		
		/**
		 * 碰撞边缘
		 */		
		public var vergePosition:Point;
		
		/**
		 * 碰撞的对象
		 */		
		public var hitObject:*;
		
		public function CollideEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:CollideEvent = new CollideEvent(type,bubbles,cancelable);
			evt.vergePosition = this.vergePosition;
			evt.hitObject = this.hitObject;
			return evt;
		}
	}
}