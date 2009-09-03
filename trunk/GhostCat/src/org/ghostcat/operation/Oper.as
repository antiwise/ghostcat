package org.ghostcat.operation
{
	import flash.events.EventDispatcher;
	
	import org.ghostcat.events.OperationEvent;
	
	[Event(name="operation_start",type="org.ghostcat.events.OperationEvent")]
	[Event(name="operation_complete",type="org.ghostcat.events.OperationEvent")]
	[Event(name="operation_error",type="org.ghostcat.events.OperationEvent")]
	
	/**
	 * 队列基类
	 * 
	 * 队列可使用Queue（顺序加载）或者GroupOper（并发加载）启动。加载队列本身同时也是一个加载器。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Oper extends EventDispatcher
	{
		public static const NONE:int = 0;
		public static const WAIT:int = 1;
		public static const RUN:int = 2;
		public static const END:int = 3;
		
		/**
		 * 当前所处的队列
		 */		
		public var queue:Queue;
		
		/**
		 * 当前状态
		 */		
		public var step:int = NONE;
		
		/**
		 * 立即执行
		 * 
		 */		
		public function execute():void
		{
			dispatchEvent(new OperationEvent(OperationEvent.OPERATION_START));
			step = RUN;
		}
		
		/**
		 * 成功函数
		 * 
		 */		
		public function result(event:*=null):void
		{
			dispatchEvent(new OperationEvent(OperationEvent.OPERATION_COMPLETE));
			step = END;
		}
		
		/**
		 * 失败函数
		 * 
		 */		
		public function fault(event:*=null):void
		{
			dispatchEvent(new OperationEvent(OperationEvent.OPERATION_ERROR));
			step = END;
		}
		
		/**
		 * 推入队列
		 * 
		 * @param queue	使用的队列，为空则为默认队列
		 * 
		 */
		public function commit(queue:Queue = null):void
		{
			if (!queue)
				queue = Queue.defaultQueue;
			
			queue.commitChild(this);
		}
		
		/**
		 * 中断队列 
		 * 
		 */
		public function halt():void
		{
			if (queue)
				queue.haltChild(this);
		}
	}
}