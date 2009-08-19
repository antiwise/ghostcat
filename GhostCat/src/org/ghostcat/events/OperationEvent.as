package org.ghostcat.events
{
	import flash.events.Event;
	
	/**
	 * 队列事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class OperationEvent extends Event
	{
		/**
		 * 队列为空时发布
		 */		
		public static const QUEUE_EMPTY:String = "queue_empty";
		
		/**
		 * 开始
		 */		
		public static const OPERATION_START:String = "operation_start";
		
		/**
		 * 请求完成
		 */		
		public static const OPERATION_COMPLETE:String = "operation_complete";
		
		/**
		 * 请求失败
		 */		
		public static const OPERATION_ERROR:String = "operation_error";
		
		public function OperationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}