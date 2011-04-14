package ghostcat.operation
{
	import flash.events.Event;
	
	import ghostcat.events.OperationEvent;
	
	[Event(name="child_operation_start",type="ghostcat.events.OperationEvent")]
	[Event(name="child_operation_complete",type="ghostcat.events.OperationEvent")]
	[Event(name="child_operation_error",type="ghostcat.events.OperationEvent")]
	/**
	 * 固定数量并发执行 
	 * @author flashyiyi
	 * 
	 */
	public class ParallelOper extends Oper implements IQueue
	{
		/**
		 * 子Oper数组 
		 */
		public var children:Array = [];
		
		/**
		 * 正在执行的Oper 
		 */
		public var running:Array = [];
		
		/**
		 * 同时并发数量
		 */
		public var queueLimit:int = 1;
		
		/**
		 * 是否在队列不为空时自动执行
		 */
		public var autoStart:Boolean = true;
		
		public function ParallelOper(children:Array=null,holdInstance:Boolean = false)
		{
			super();
			
			this.holdInstance = holdInstance;
			
			if (!children)
				children = [];
			
			for (var i:int = 0;i < children.length;i++)
			{
				var obj:Oper = children[i] as Oper;
				obj.queue = this;
				obj.step = Oper.WAIT;
			}
			this.children = children;
		}
		
		public override function execute():void
		{
			super.execute();
			doLoad();
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
			if (autoStart && children.length == 1)
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
			
			var index:int = running.indexOf(obj);
			if (index != -1)
			{
				//如果正在加载，则跳到下一个
				children.splice(index,1);
				doLoad();
			}
		}
		
		private function doLoad():void
		{
			if (running.length < queueLimit)
			{	
				if (children.length > 0)
				{
					var oper:Oper = children.shift();
					running.push(oper);
					
					oper.addEventListener(OperationEvent.OPERATION_START,starthandler);
					oper.addEventListener(OperationEvent.OPERATION_COMPLETE,nexthandler);
					oper.addEventListener(OperationEvent.OPERATION_ERROR,nexthandler);
					oper.execute();
				}
				else
				{
					if (running.length == 0)
						result();
				}
			}
		}
		
		private function starthandler(event:OperationEvent):void
		{
			var oper:Oper = event.currentTarget as Oper;
			oper.removeEventListener(OperationEvent.OPERATION_START,starthandler);
			
			var e:OperationEvent = new OperationEvent(OperationEvent.CHILD_OPERATION_START);
			e.oper = this;
			e.childOper = oper;
			dispatchEvent(e);
		}
		
		private function nexthandler(event:OperationEvent):void
		{
			var oper:Oper = event.currentTarget as Oper;
			oper.removeEventListener(OperationEvent.OPERATION_START,starthandler);
			oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,nexthandler);
			oper.removeEventListener(OperationEvent.OPERATION_ERROR,nexthandler);
			
			var index:int = running.indexOf(oper);
			if (index != -1)
				running.splice(index,1);
			
			if (oper.continueWhenFail || event.type == OperationEvent.OPERATION_COMPLETE)
				doLoad();
			else
				fault(event);
		
			var e:OperationEvent = new OperationEvent(event.type == OperationEvent.OPERATION_COMPLETE ? OperationEvent.CHILD_OPERATION_COMPLETE : OperationEvent.CHILD_OPERATION_ERROR);
			e.oper = this;
			e.childOper = oper;
			e.result = event.result;
			dispatchEvent(e);
		}
		
		/** @inheritDoc*/
		public override function halt() : void
		{
			super.halt();
			
			for each (var child:Oper in running)
				child.halt();
			
			running = [];
		}
	}
}