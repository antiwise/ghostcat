package ghostcat.operation
{
	import ghostcat.events.OperationEvent;
	
	/**
	 * 条件分支
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SwitchOper extends Oper
	{
		/**
		 * 检测函数 
		 */
		public var cHandler:Function;
		/**
		 * 分支列表，元素为二维数组，第一项为值，第二项为需要执行的Oper
		 */
		public var list:Array;
		/**
		 * 默认Oper
		 */
		public var defaultOper:Oper;
		
		private var choose:Oper;
		
		public function SwitchOper(cHandler:Function,list:Array,defaultOper:Oper = null)
		{
			super();
			this.cHandler = cHandler;
			this.list = list;
			this.defaultOper = defaultOper;
		}
		
		public override function execute():void
		{
			super.execute();
			
			var result:* = cHandler();
			for (var i:int = 0;i < list.length;i++)
			{
				if (result == list[i][0])
				{
					choose = list[i][1];
					break;
				}
			}
			
			if (choose == null)
				choose = defaultOper;
			
			addHandlers();
			choose.execute();
		}
		
		public override function result(event:*=null):void
		{
			super.result(event);
			removeHandlers()
		}
		
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