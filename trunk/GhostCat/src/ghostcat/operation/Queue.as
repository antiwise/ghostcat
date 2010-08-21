package ghostcat.operation
{
	import flash.events.Event;
	
	import ghostcat.debug.Debug;
	import ghostcat.events.OperationEvent;
	
	/**
	 * 队列系统
	 * 
	 * 引用defaultQueue将会创建默认queue。而这个默认queue是最常用的，一般情况下不需要再手动创建队列。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class Queue extends Oper implements IQueue
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
		
		/**
		 * 子Oper数组 
		 */
		public var children:Array = [];
		
		
		public function Queue(children:Array=null,holdInstance:Boolean = false)
		{
			super();
			
			if (!children)
				children = [];
			
			this.children = children;
			this.holdInstance = holdInstance;
		}
		
		/**
		 * 推入队列
		 * 
		 */			
		public function commitChild(obj:Oper):void
		{
			obj.queue = this;
			obj.step = Oper.WAIT;
			
			children.push(obj);
			if (children.length == 1)
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
			
			var index:int = children.indexOf(obj);
			if (index == -1)
				return;
			
			if (index == 0)//如果正在加载，而跳到下一个
				nexthandler();
			else
				children.splice(index,1);
		}
		
		private function doLoad():void
		{
			if (children.length > 0)
			{
				var oper:Oper = children[0];
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
			var oper:Oper = children[0] as Oper;
			oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,nexthandler);
			oper.removeEventListener(OperationEvent.OPERATION_ERROR,nexthandler);
			
			children.shift();
		
			if (oper.continueWhenFail || event.type == OperationEvent.OPERATION_COMPLETE)
				doLoad();
		}
		/** @inheritDoc*/
		public override function commit(queue:Queue=null) : void
		{
			if (!queue)
				queue = Queue.defaultQueue;
			
			if (queue == this)
				Debug.error("不能将自己推入自己的队列中")
			else
				super.commit(queue);
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			
			doLoad();
		}
		
		/** @inheritDoc*/
		public override function halt() : void
		{
			super.halt();
			
			if (children.length > 0)
			{
				children = children.slice(0,1);
				(children[0] as Oper).halt();
			}
		}
		
	}
}
