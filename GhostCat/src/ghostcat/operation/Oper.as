package ghostcat.operation
{
	import flash.events.EventDispatcher;
	
	import ghostcat.events.OperationEvent;
	import ghostcat.util.core.AbstractUtil;
	
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
	 * 事件调用顺序：result -> resultFuncition -> end -> 触发OPERATION_COMPLETE事件 -> 触发队列的CHILD_OPERATION_COMPLETE -> 执行下个队列
	 * 重写result方法要注意它的super.result会立即启动下个队列，因此需要放在最后（如果没有队列则会中断）。或者用重写resultFuncition代替，它一定是在队列切换前执行的。
	 * 而end方法无论成功或者失败都已经执行，可以在此放置回收代码。 
	 *
	 * @author flashyiyi
	 * 
	 */
	public class Oper extends EventDispatcher implements IOper
	{
		public static const NONE:int = 0;
		public static const WAIT:int = 1;
		public static const RUN:int = 2;
		public static const END:int = 3;
		
		public function Oper()
		{
			AbstractUtil.preventConstructor(this,Oper);	
		}
		
		/**
		 * 标示
		 */
		public var id:String;
		
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
		 * 是否不等待而立即执行下一个Oper
		 */
		public var immediately:Boolean = false;
		
		/**
		 * 是否在出错的时候继续队列
		 */
		public var continueWhenFail:Boolean = true;
		
		/**
		 * 立即执行
		 * 
		 */		
		public function execute():void
		{
			var e:OperationEvent = new OperationEvent(OperationEvent.OPERATION_START);
			e.oper = this;
			dispatchEvent(e);
			
			if (queue)
			{
				e = new OperationEvent(OperationEvent.CHILD_OPERATION_START);
				e.oper = queue;
				e.childOper = this;
				queue.dispatchEvent(e);
			}
			
			step = RUN;
			
			if (immediately)//立即执行则立即触发完成事件
			{
				e = new OperationEvent(OperationEvent.OPERATION_COMPLETE);
				e.oper = this;
				dispatchEvent(e);
				
				if (queue)
				{
					e = new OperationEvent(OperationEvent.CHILD_OPERATION_COMPLETE);
					e.oper = queue;
					e.childOper = this;
					dispatchEvent(e);
				}
			}
		}
		
		/**
		 * 调用成功函数
		 * 
		 */		
		public function result(event:*=null):void
		{
			lastResult = event;
			
			resultFunction(event);
			end(event);
			
			var e:OperationEvent = new OperationEvent(OperationEvent.OPERATION_COMPLETE);
			e.oper = this;
			e.result = event;
			dispatchEvent(e);
			
			if (queue)
			{
				e = new OperationEvent(OperationEvent.CHILD_OPERATION_COMPLETE);
				e.oper = queue;
				e.childOper = this;
				e.result = event;
				dispatchEvent(e);
				
				this.queue = null;
			}
			
			step = END;
		}
		
		/**
		 * 调用失败函数
		 * 
		 */		
		public function fault(event:*=null):void
		{
			lastResult = event;
			
			failFunction(event);
			end(event);
			
			var e:OperationEvent = new OperationEvent(OperationEvent.OPERATION_ERROR);
			e.oper = this;
			e.result = event;
			dispatchEvent(e);
			
			if (queue)
			{
				e = new OperationEvent(OperationEvent.CHILD_OPERATION_ERROR);
				e.oper = queue;
				e.childOper = this;
				e.result = event;
				dispatchEvent(e);
				
				this.queue = null;
			}
			
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
		 * 成功函数
		 * @param event
		 * 
		 */
		protected function resultFunction(event:*=null):void
		{
			
		}

		/**
		 * 失败函数
		 * @param event
		 * 
		 */
		protected function failFunction(event:*=null):void
		{
			
		}
		
		/**
		 * 结束函数 
		 * @param event
		 * 
		 */
		protected function end(event:*=null):void
		{
			
		}
		
		/**
		 * 中断队列 
		 * 
		 */
		public function halt():void
		{
			end();
			
			if (queue)
				queue.haltChild(this);
		}
	}
}