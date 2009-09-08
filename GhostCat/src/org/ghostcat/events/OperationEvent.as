package org.ghostcat.events
{
	import flash.events.Event;
	
	import org.ghostcat.operation.Oper;
	
	/**
	 * 队列事件
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class OperationEvent extends Event
	{
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
		
		/**
		 * 子对象开始
		 */		
		public static const CHILD_OPERATION_START:String = "child_operation_start";
		
		/**
		 * 子对象请求完成
		 */		
		public static const CHILD_OPERATION_COMPLETE:String = "child_operation_complete";
		
		/**
		 * 子对象请求失败
		 */		
		public static const CHILD_OPERATION_ERROR:String = "child_operation_error";
		
		/**
		 * 加载器
		 */
		public var oper:Oper;
		
		/**
		 * 子加载器
		 */
		public var childOper:Oper;
		
		/**
		 * 返回结果
		 */
		public var result:*;
		
		public function OperationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone() : Event
		{
			var evt:OperationEvent = new OperationEvent(type,bubbles,cancelable);
			evt.oper = this.oper;
			evt.childOper = this.childOper;
			evt.result = this.result;
			return evt;
		}
	}
}