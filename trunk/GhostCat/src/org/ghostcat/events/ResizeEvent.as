package org.ghostcat.events
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 缩放事件 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ResizeEvent extends Event
	{
		/**
		 * 大小变化 
		 */
		public static const RESIZE:String = "resize";
		
		/**
		 * 缩放后新的大小
		 */
		public var size:Point;
		
		public function ResizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}