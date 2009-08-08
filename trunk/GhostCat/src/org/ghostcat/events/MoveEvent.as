package org.ghostcat.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
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