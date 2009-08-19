package org.ghostcat.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 移动事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class MoveEvent extends Event
	{
		public static const MOVE:String = "move";
		
		public var oldPosition:Point;
		
		public var newPosition:Point;
		
		public function MoveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}