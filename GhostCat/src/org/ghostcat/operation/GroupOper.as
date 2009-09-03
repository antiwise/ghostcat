package org.ghostcat.operation
{
	import org.ghostcat.events.OperationEvent;
	import org.ghostcat.util.Util;

	/**
	 * 同时处理多个操作，用于不需要排队的情况
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GroupOper extends Oper
	{
		public var group:Array;
		
		public function GroupOper(parms:Array)
		{
			group = [];
			for (var i:int = 0; i<parms.length; i++)
				commitChild(parms[i] as Oper);
		}
		
		/**
		 * 推入队列
		 * 
		 */			
		public function commitChild(obj:Oper):void
		{
			group.push(obj);
		}
		
		/**
		 * 移出队列
		 * 
		 */
		public function haltChild(obj:Oper):void
		{
			Util.remove(group,obj);
			if (group.length==0)
				result();
		}
		
		public override function execute():void
		{
			super.execute();
			for (var i:int = 0; i<group.length; i++)
			{
				var oper:Oper = group[i] as Oper;
				oper.addEventListener(OperationEvent.OPERATION_COMPLETE,childCompleteHandler);
				oper.addEventListener(OperationEvent.OPERATION_ERROR,childErrorHandler);
				oper.execute();
			}
		}
		
		private function childCompleteHandler(event:OperationEvent):void
		{
			endOperation(event.currentTarget as Oper);
		}
		
		private function childErrorHandler(event:OperationEvent):void
		{
			endOperation(event.currentTarget as Oper);
		}
		
		private function endOperation(oper:Oper):void
		{
			oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,childCompleteHandler);
			oper.removeEventListener(OperationEvent.OPERATION_ERROR,childErrorHandler);
			haltChild(oper);
			
			if (group.length==0)
				result();
		}

	}
}