package ghostcat.operation
{
	import ghostcat.events.OperationEvent;

	/**
	 * 循环执行某段代码
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RepeatOper extends Oper
	{
		/**
		 * 操作列表
		 */
		public var list:Array;
		/**
		 * 循环次数 
		 */
		public var loop:int;
		/**
		 * 位置
		 */
		public var index:int = 0;
		
		public function RepeatOper(list:Array,loop:int = -1)
		{
			this.list = list;
			this.loop = loop;
		}
		
		public override function execute():void
		{
			super.execute();
			
			addHandlers();
			
			index = 0;
			var oper:Oper = list[index] as Oper;
			oper.execute();
		}
		
		public override function result(event:* = null) : void
		{
			super.result(event);
			removeHandlers();
		}
		
		public override function fault(event:* = null) : void
		{
			super.fault(event);
			removeHandlers();
		}
		
		private function addHandlers():void
		{
			for (var i:int = 0;i < list.length;i++)
			{
				var oper:Oper = list[i] as Oper;
				oper.addEventListener(OperationEvent.OPERATION_COMPLETE,nextOperation);
				oper.addEventListener(OperationEvent.OPERATION_ERROR,fault);
			}
		}
		
		private function removeHandlers():void
		{
			for (var i:int = 0;i < list.length;i++)
			{
				var oper:Oper = list[i] as Oper;
				oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,nextOperation);
				oper.removeEventListener(OperationEvent.OPERATION_ERROR,fault);
			}
		}
		
		private function nextOperation(event:OperationEvent):void
		{
			index++;
			if (index > list.length - 1)
			{
				loop--;
				index = 0;
				if (loop == 0)
				{
					result();
					return;
				}
			}
			
			var oper:Oper = list[index];
			oper.execute();
		}		
	}
}