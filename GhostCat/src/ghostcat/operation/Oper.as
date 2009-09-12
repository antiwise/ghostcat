package ghostcat.operation
{
	import flash.events.EventDispatcher;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.util.Util;
	
	[Event(name="operation_start",type="ghostcat.events.OperationEvent")]
	[Event(name="operation_complete",type="ghostcat.events.OperationEvent")]
	[Event(name="operation_error",type="ghostcat.events.OperationEvent")]
	[Event(name="child_operation_start",type="ghostcat.events.OperationEvent")]
	[Event(name="child_operation_complete",type="ghostcat.events.OperationEvent")]
	[Event(name="child_operation_error",type="ghostcat.events.OperationEvent")]
	
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
		 * 名称
		 */
		public var name:String;
		
		/**
		 * 当前所处的队列
		 */		
		public var queue:Queue;
		
		/**
		 * 当前状态
		 */		
		public var step:int = NONE;
		
		/**
		 * 最后一次的结果
		 */
		public var lastResult:*;
		
		/**
		 * 立即执行
		 * 
		 */		
		public function execute():void
		{
			dispatchEvent(Util.createObject(new OperationEvent(OperationEvent.OPERATION_START),{oper:this}));
			if (queue) 
				queue.dispatchEvent(Util.createObject(new OperationEvent(OperationEvent.CHILD_OPERATION_START),{oper:queue,childOper:this}));
			
			step = RUN;
		}
		
		/**
		 * 成功函数
		 * 
		 */		
		public function result(event:*=null):void
		{
			lastResult = event;
			
			dispatchEvent(Util.createObject(new OperationEvent(OperationEvent.OPERATION_COMPLETE),{oper:this,result:event}));
			if (queue) 
				queue.dispatchEvent(Util.createObject(new OperationEvent(OperationEvent.CHILD_OPERATION_COMPLETE),{oper:queue,childOper:this,result:event}));
			
			step = END;
		}
		
		/**
		 * 失败函数
		 * 
		 */		
		public function fault(event:*=null):void
		{
			lastResult = event;
			
			dispatchEvent(Util.createObject(new OperationEvent(OperationEvent.OPERATION_ERROR),{oper:this,result:event}));
			if (queue) 
				queue.dispatchEvent(Util.createObject(new OperationEvent(OperationEvent.CHILD_OPERATION_ERROR),{oper:queue,childOper:this,result:event}));
			
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