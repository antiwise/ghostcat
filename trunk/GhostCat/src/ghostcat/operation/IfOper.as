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
			
			choose = cHandler() ? b1 : b2;
			choose.addEventListener(OperationEvent.OPERATION_COMPLETE,result);
			choose.addEventListener(OperationEvent.OPERATION_ERROR,fault);
			choose.execute();
		}
		/** @inheritDoc*/
		protected override function end(event:*=null):void
		{
			super.end(event);
			
			choose.removeEventListener(OperationEvent.OPERATION_COMPLETE,result);
			choose.removeEventListener(OperationEvent.OPERATION_ERROR,fault);
		}
	}
}