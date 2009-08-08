package org.ghostcat.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ResizeEvent extends Event
	{
		/**
		 * 大小变化 
		 */
		public static const RESIZE:String = "resize";
		
		public var size:Point;
		
		public function ResizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}