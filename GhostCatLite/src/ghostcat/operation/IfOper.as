package ghostcat.operation
{
	import ghostcat.events.OperationEvent;
	import ghostcat.util.core.Handler;
	
	/**
	 * 条件判断
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class IfOper extends Oper
	{
		/**
		 * 检测函数
		 */
		public var cHandler:Handler;
		/**
		 * cHandler返回true时执行
		 */
		public var b1:Oper;
		/**
		 * cHandler返回false时执行
		 */
		public var b2:Oper;
		
		private var choose:Oper;
		
		public function IfOper(cHandler:*=null,b1:Oper=null,b2:Oper=null)
		{
			super();
			if (cHandler is Handler)
				this.cHandler = cHandler;
			else
				this.cHandler = new Handler(cHandler);
			
			this.b1 = b1;
			this.b2 = b2;
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			
			choose = cHandler.call() ? b1 : b2;
			if (choose)
			{
				choose.addEventListener(OperationEvent.OPERATION_COMPLETE,result);
				choose.addEventListener(OperationEvent.OPERATION_ERROR,fault);
				choose.execute();
			}
			else
			{
				result();
			}
		}
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			super.end(event);
			
			if (choose)
			{
				choose.removeEventListener(OperationEvent.OPERATION_COMPLETE,result);
				choose.removeEventListener(OperationEvent.OPERATION_ERROR,fault);
			}
		}
	}
}