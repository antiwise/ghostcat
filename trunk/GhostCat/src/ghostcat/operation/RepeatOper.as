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
		public var children:Array;
		/**
		 * 循环次数 
		 */
		public var loop:int;
		/**
		 * 位置
		 */
		public var index:int = 0;
		
		public function RepeatOper(children:Array=null,loop:int = -1)
		{
			this.children = children;
			this.loop = loop;
		}
		
		public override function execute():void
		{
			super.execute();
			
			for (var i:int = 0;i < children.length;i++)
			{
				var oper:Oper = children[i] as Oper;
				oper.addEventListener(OperationEvent.OPERATION_COMPLETE,nextOperation);
				oper.addEventListener(OperationEvent.OPERATION_ERROR,fault);
			};
			
			this.index = 0;
			
			if (children && children.length > 0)
				(children[0]).execute();
		}
		
		protected override function end(event:* = null) : void
		{
			super.end(event);
			
			for (var i:int = 0;i < children.length;i++)
			{
				var oper:Oper = children[i] as Oper;
				oper.removeEventListener(OperationEvent.OPERATION_COMPLETE,nextOperation);
				oper.removeEventListener(OperationEvent.OPERATION_ERROR,fault);
			}
		}
		
		private function nextOperation(event:OperationEvent):void
		{
			index++;
			if (index > children.length - 1)
			{
				loop--;
				index = 0;
				if (loop == 0)
				{
					result();
					return;
				}
			}
			
			var oper:Oper = children[index];
			oper.execute();
		}		
	}
}