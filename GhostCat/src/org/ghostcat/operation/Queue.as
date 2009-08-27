package org.ghostcat.operation
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.ghostcat.events.OperationEvent;

	[Event(name="queue_empty",type="org.ghostcat.events.OperationEvent")]

	/**
	 * 队列系统
	 * 
	 * 引用defaultQueue将会创建默认queue。而这个默认queue是最常用的，一般情况下不需要再手动创建队列。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class Queue extends EventDispatcher
	{
		private static var _defaultQueue:Queue;
		
		/**
		 * 默认队列
		 */		
		public static function get defaultQueue():Queue
		{
			if (!_defaultQueue)
				_defaultQueue = new Queue();
			return _defaultQueue;
		}
		
		public var queue:Array = [];
		
		/**
		 * 推入队列
		 * 
		 */			
		public function commit(obj:Oper):void
		{
			obj.queue = this;
			obj.step = Oper.WAIT;
			
			queue.push(obj);
			if (queue.length == 1)
				doLoad();
		}
		
		/**
		 * 移出队列
		 * 
		 */
		public function halt(obj:Oper):void
		{
			obj.queue = null;
			obj.step = Oper.NONE;
			
			var index:int = queue.indexOf(obj);
			if (index == -1)
				return;
			
			if (index == 0)//如果正在加载，而跳到下一个
				nexthandler();
			else
				queue.splice(index,1);
		}
		
		private function doLoad():void
		{
			if (queue.length > 0)
			{
				var oper:Oper = queue[0];
				oper.addEventListener(OperationEvent.OPERATION_COMPLETE,nexthandler);
				oper.addEventListener(OperationEvent.OPERATION_ERROR,nexthandler);
				oper.execute();
			}
			else
			{
				dispatchEvent(new OperationEvent(OperationEvent.QUEUE_EMPTY))
			}
		}
		
		private function nexthandler(event:Event=null):void
		{
			var loader:Oper = queue[0] as Oper;
			loader.removeEventListener(OperationEvent.OPERATION_COMPLETE,nexthandler);
			loader.removeEventListener(OperationEvent.OPERATION_ERROR,nexthandler);
			
			queue.shift();
		
			doLoad();
		}
		
	}
}
