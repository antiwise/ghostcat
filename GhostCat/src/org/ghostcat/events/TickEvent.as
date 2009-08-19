package org.ghostcat.events
{
	import flash.events.Event;
	
	/**
	 * 屏幕更新事件
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class TickEvent extends Event
	{
		/**
		 * 实际上便是ENTER_FRAME
		 */		
		public static const TICK:String="tick";
		
		/**
		 * 两次发布事件的毫秒间隔
		 */		
		public var interval:int;
		
		/**
		 * 用于Tick的发布事件
		 * 
		 * @param type	类型
		 * @param interval	两次事件的毫秒间隔
		 * 
		 */		
		public function TickEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}