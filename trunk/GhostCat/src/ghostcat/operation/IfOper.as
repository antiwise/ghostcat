package ghostcat.operation
{
	import ghostcat.events.OperationEvent;
	
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
		public var cHandler:Function;
		/**
		 * cHandler返回true时执行
		 */
		public var b1:Oper;
		/**
		 * cHandler返回false时执行
		 */
		public var b2:Oper;
		
		private var choose:Oper;
		
		public function IfOper(cHandler:Function=null,b1:Oper=null,b2:Oper=null)
		{
			super();
			this.cHandler = cHandler;
			this.b1 = b1;
			this.b2 = b2;
		}
		/** @inheritDoc*/
		public override function execute():void
		{
			super.execute();
			
			if (cHandler())
				choose = b1;
			else
				choose = b2;
			
			addHandlers();
			choose.execute();
		}
		/** @inheritDoc*/
		public override function result(event:*=null):void
		{
			super.result(event);
			removeHandlers()
		}
		/** @inheritDoc*/
		public override function fault(event:*=null):void
		{
			super.fault(event);
			removeHandlers()
		}
		
		private function addHandlers():void
		{
			choose.addEventListener(OperationEvent.OPERATION_COMPLETE,result);
			choose.addEventListener(OperationEvent.OPERATION_ERROR,fault);
		}
		
		private function removeHandlers():void
		{
			choose.removeEventListener(OperationEvent.OPERATION_COMPLETE,result);
			choose.removeEventListener(OperationEvent.OPERATION_ERROR,fault);
		}
	}
}