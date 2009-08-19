package org.ghostcat.events
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * 选中事件
	 * @author flashyiyi
	 * 
	 */
	public class SelectEvent extends Event
	{
		/**
		 * 选中事件
		 */
		public static const SELECT:String = "select";
		
		/**
		 * 选中框矩形
		 */
		public var rect:Rectangle;
		
		public function SelectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}