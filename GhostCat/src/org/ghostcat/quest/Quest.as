package org.ghostcat.quest
{
	import flash.events.EventDispatcher;
	
	import org.ghostcat.debug.Debug;
	import org.ghostcat.events.OperationEvent;
	import org.ghostcat.operation.Oper;
	import org.ghostcat.operation.Queue;

	[Event(name="quest_complete",type="org.ghostcat.quest.QuestEvent")]
	
	public class Quest extends EventDispatcher
	{
		public var id:int = 0;
		private var queue:Queue;
		private var opers:Array;
		
		public var activeHandler:Function;
		
		private var _step:int = 0;
		
		public function get step():int
		{
			return _step;
		}

		public function set step(v:int):void
		{
			if (started)
				Debug.error("已经开始的任务不能再设置阶段")
			else
				_step = v;
		}
		
		/**
		 * 
		 * @param v	Oper列表
		 * @param activeHandler	判断任务是否可接受
		 * @param step	当前执行到的步骤
		 * 
		 */
		public function Quest(v:Array=null,activeHandler:Function=null,step:int = 0)
		{
			this.opers = v;
			this.activeHandler = activeHandler;
			this.step = step;
		}
		
		public function get enabled():Boolean
		{
			return activeHandler==null || activeHandler.call();
		}
		
		public function get started():Boolean
		{
			return queue != null;
		}
		
		public function get finish():Boolean
		{
			return queue && queue.queue.length == 0;
		}
		
		public function start():void
		{
			queue = new Queue();
			queue.addEventListener(OperationEvent.QUEUE_EMPTY,queueEmptyHandler);
			for (var i:int = step; i< opers.length;i++)
				queue.commit(opers[i] as Oper);
		}
		
		private function queueEmptyHandler(event:OperationEvent):void
		{
			var e:QuestEvent = new QuestEvent(QuestEvent.QUEST_COMPLETE);
			e.id = this.id;
			dispatchEvent(e);
		}
	}
}