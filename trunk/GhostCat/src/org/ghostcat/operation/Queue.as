package org.ghostcat.operation
{
	import flash.events.Event;
	
	import org.ghostcat.debug.Debug;
	import org.ghostcat.events.OperationEvent;

	/**
	 * 队列系统
	 * 
	 * 引用defaultQueue将会创建默认queue。而这个默认queue是最常用的，一般情况下不需要再手动创建队列。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class Queue extends Oper
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
		
		public var data:Array = [];
		
		
		public function Queue(data:Array=null)
		{
			super();
			
			if (!data)
				data = [];
			this.data = data;
		}
		
		/**
		 * 推入队列
		 * 
		 */			
		public function commitChild(obj:Oper):void
		{
			obj.queue = this;
			obj.step = Oper.WAIT;
			
			data.push(obj);
			if (data.length == 1)
				doLoad();
		}
		
		/**
		 * 移出队列
		 * 
		 */
		public function haltChild(obj:Oper):void
		{
			obj.queue = null;
			obj.step = Oper.NONE;
			
			var index:int = data.indexOf(obj);
			if (index == -1)
				return;
			
			if (index == 0)//如果正在加载，而跳到下一个
				nexthandler();
			else
				data.splice(index,1);
		}
		
		private function doLoad():void
		{
			if (data.length > 0)
			{
				var oper:Oper = data[0];
				oper.addEventListener(OperationEvent.OPERATION_COMPLETE,nexthandler);
				oper.addEventListener(OperationEvent.OPERATION_ERROR,nexthandler);
				oper.execute();
			}
			else
			{
				result();
			}
		}
		
		private function nexthandler(event:Event=null):void
		{
			var loader:Oper = data[0] as Oper;
			loader.removeEventListener(OperationEvent.OPERATION_COMPLETE,nexthandler);
			loader.removeEventListener(OperationEvent.OPERATION_ERROR,nexthandler);
			
			data.shift();
		
			doLoad();
		}
		
		public override function commit(queue:Queue=null) : void
		{
			if (!queue)
				queue = Queue.defaultQueue;
			
			if (queue == this)
				Debug.error("不能将自己推入自己的队列中")
			else
				super.commit(queue);
		}
		
		public override function execute() : void
		{
			super.execute();
			
			if (data && data.length > 0)
				commitChild(data[0] as Oper);
		}
		
	}
}
